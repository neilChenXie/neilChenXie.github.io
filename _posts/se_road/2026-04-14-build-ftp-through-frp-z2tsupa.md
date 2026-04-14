---
title: 通过frp搭建FTP
date: '2026-04-14 23:10:00'
permalink: /post/build-ftp-through-frp-z2tsupa.html
tags:
  - operation｜运维
categories:
  - Maintainance｜运维
layout: post
published: true
---



## 摘要

### 下载

```bash
# 先查看cpu的架构
uname -m

# 如果是x86_64,则选amd64，如果是arm64,则选arm64

wget https://github.com/fatedier/frp/releases/download/v0.68.0/frp_0.68.0_linux_amd64.tar.gz
tar -xzf frp_0.68.0_linux_amd64.tar.gz
cd frp_0.68.0_linux_amd64
```

### 服务器端

配置frps.toml文件（FRP v0.52.0+ 使用 **TOML** 格式，旧版用 INI 格式）

```toml
# frps.toml
# ============ 绑定端口 ============
bindPort = 7000

# ============ Dashboard 面板 ============
webServer.addr = "0.0.0.0"
webServer.port = 7500
webServer.user = "admin"
webServer.password = "your_password"

# ============ 认证 Token ============
auth.method = "token"
auth.token = "your_secret_token_here"

# ============ 日志配置 ============
log.to = "/var/log/frps.log"
log.level = "info"
log.maxDays = 7

# ============ TLS 配置（可选） ============
# transport.tls.force = true
# transport.tls.certFile = "/path/to/server.crt"
# transport.tls.keyFile = "/path/to/server.key"
```

Linux通过systemd启动服务，配置如下

```bash
# /etc/systemd/system/frps.service

[Unit]
Description=FRP Server
After=network.target

[Service]
Type=simple
#User=nobody #会导致无法访问//home/admin/下的文件
Restart=on-failure
RestartSec=5s
ExecStart=/home/admin/tools/frp/frps -c /home/admin/tools/frp/frps.toml #修改成相应的执行文件和配置文件路径
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
```

启动服务

```bash
sudo systemctl daemon-reload
sudo systemctl enable frps
sudo systemctl start frps
sudo systemctl status frps
```

防火墙放行（阿里云服务器直接在Web设置中放开相关端口即可）：

```bash
# 必须开放的端口
sudo ufw allow 7000/tcp    # frp 主端口
sudo ufw allow 7500/tcp    # Dashboard

# 如果使用 HTTP/HTTPS 代理
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 如果有端口映射范围
sudo ufw allow 20000:30000/tcp
```

阿里云的安全组，也需要打开：

- ​**7000**：FRP服务端与客户端通信端口
- ​**7500**：FRP管理面板端口
- ​**2121**：FTP控制端口（映射后的）
- **20000-30000**：FTP被动模式数据端口范围

### OpenClaw电脑端

#### Macbook

##### 打开Mac自带的SFTP服务：

打开 **系统设置** -\> **通用** -\> **共享** -\> 打开 **远程登录**（Remote Login），将当前用户（chenxie）加入可访问  
\*(这就开启了 SFTP，端口固定为 22)\*

![Screen Shot 2026-04-14 at 22.57.19](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadScreen Shot 2026-04-14 at 22.57.19-20260414225815-21dfatw.png)

##### 设置frpc.toml文件

```toml
serverAddr = "你的阿里云公网IP"
serverPort = 7000
auth.method = "token"
auth.token = "你在frps.toml里设置的token"

[[proxies]]
name = "mac-sftp"
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = 6022  # 暴露在阿里云上的端口
```

##### 在阿里云防火墙打开6022端口

```bash
# 阿里云在web页面设置即可。

#其他Linux服务器：Ubuntu
sudo ufw allow 6022/tcp

# CentOS
sudo firewall-cmd --permanent --add-port=6022/tcp && sudo firewall-cmd --reload
```

##### 启动frpc

```bash
./frpc -c frpc.ini
```

##### 链接尝试

用任何 FTP 软件（如 FileZilla），新建连接：

- 协议选：**SFTP**
- 主机：`你的阿里云公网IP`
- 端口：`6022`
- 用户名：`你Mac的开机用户名`​（终端输入 `whoami` 可以看到）
- 密码：`你Mac的开机密码`

##### **像systemctl一样启动frpc**

写一个 launchd 的 plist（类似 systemd 的 service）

```bash
nano ~/Library/LaunchAgents/com.frpc.plist
```

com.frpc.plist内容如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.frpc</string>

    <key>ProgramArguments</key>
    <array>
        <string>/Users/admin/tools/frp/frpc</string>
        <string>-c</string>
        <string>/Users/admin/tools/frp/frpc.toml</string>
    </array>

    <!-- 自动拉起 + 登录时自动运行 -->
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>

    <!-- 日志输出（方便排查） -->
    <key>StandardOutPath</key>
    <string>/Users/admin/tools/frp/frpc.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/admin/tools/frp/frpc.err</string>
</dict>
</plist>

```

要点说明（对标 systemd 的 `frpc.service`）：

- ​`Label`：类似 Service 名，必须唯一。
- ​`ProgramArguments`​：`ExecStart=`​ 的等价物，要写绝对路径。`-c ./frpc.toml`​ 拆成数组元素。`ProgramArguments` 是启动 daemon 必填字段apple.com。
- ​`KeepAlive`​：对应 `Restart=always`，进程挂了就自动重启apple.com。
- ​`RunAtLoad`​：类似 `WantedBy=multi-user.target`，加载时即启动。
- ​`StandardOutPath / StandardErrorPath`​：stdout/stderr 写到文件，方便 `tail -f` 看日志apple.com。

启动

```bash
launchctl load -w ~/Library/LaunchAgents/com.frpc.plist

# 查看状态
launchctl list | grep com.frpc
# 正常会看到一行类似：
# 12345  0  com.frpc
# 第二个数字是 exit status，0 表示正常；如果有异常会是非 0

# 如果要停止
launchctl unload -w ~/Library/LaunchAgents/com.frpc.plist
```

## 生产环境：含vhostHTTPPort和vhostHTTPSPort

服务端配置

```toml
# frps.toml - 生产环境推荐配置

# 基础绑定
bindPort = 7000
# 如需同时支持 kcp 协议
# bindKCP = 7000

# HTTP/HTTPS 反向代理
vhostHTTPPort = 80
vhostHTTPSPort = 443

# Dashboard
webServer.addr = "0.0.0.0"
webServer.port = 7500
webServer.user = "admin"
webServer.password = "StrongP@ssw0rd!"

# 安全认证
auth.method = "token"
auth.token = "my_secure_token_2024"

# 连接限制
maxPoolCount = 100
maxPortsPerClient = 20
allowPorts = [
    { start = 20000, end = 30000 }
]

# 子域名配置
subdomainHost = "frp.example.com"

# 日志
log.to = "/var/log/frps.log"
log.level = "warn"
log.maxDays = 7

# 传输优化
transport.tcpMux = true
transport.tcpMuxKeepaliveInterval = 60
transport.tcpKeepalive = 7200

```

简单来说，`vhostHTTPPort`​ 和 `vhostHTTPSPort`​ 的作用是：**让你可以用「不同的域名」来区分和访问不同的内网服务，而不需要为每个服务开放一个新的端口号。**   
这叫做 **虚拟主机反向代理**。

---

### 一、如果没有这两个配置会怎样？

假设你有两台内网电脑，都要暴露 Web 服务：

- 电脑 A 跑了一个博客（本地端口 8080）
- 电脑 B 跑了一个导航页（本地端口 8081）  
  **不用 vhost 时的做法（TCP 模式）：**   
  你必须在服务器上占用**两个不同的公网端口**。
- 用户访问博客：`http://你的服务器IP:8080`
- 用户访问导航：`http://你的服务器IP:8081`
- **缺点**：不美观、要记端口号、防火墙要开一堆端口。

---

### 二、配置了这两个端口后的效果

如果你在服务端设置了：

```toml
vhostHTTPPort = 80
vhostHTTPSPort = 443
```

同时在域名解析那里，把两个域名都 A 记录指向你的服务器 IP：

- ​`blog.example.com` -> 服务器IP
- ​`nav.example.com`​ -> 服务器IP  
  **用户访问方式变成：**
- 用户访问博客：`http://blog.example.com` （默认80端口）
- 用户访问导航：`http://nav.example.com`​ （默认80端口）  
  **FRP 在中间做了什么？**   
  当请求到达服务器的 `80`​ 端口时，FRP 会偷偷看一眼 HTTP 请求头里的 `Host` 字段：
- 如果发现是 `blog.example.com`，就把流量丢给电脑 A。
- 如果发现是 `nav.example.com`，就把流量丢给电脑 B。

---

### 三、两者的区别

|配置项|监听协议|适用场景|客户端对应 type|
| --------| -------------| ----------------------------| -----------------|
|​`vhostHTTPPort`|HTTP|普通网站、不需要加密的接口|​`type = "http"`|
|​`vhostHTTPSPort`|HTTPS (TLS)|需要安全传输的网站|​`type = "https"`|

#### 关于 HTTPS 的一个重要细节（SNI 转发）

当用户访问 `https://blog.example.com`​ 时，流量是加密的，FRP 服务端看不到 `Host`​ 头。  
**它是怎么区分的？**   
依靠 **SNI (Server Name Indication)** 。在建立 HTTPS 连接的最初阶段，客户端会明文发送它要访问的域名，FRP 就是根据这个 SNI 信息来决定把流量转发给哪个客户端的。

> **注意**：使用 `vhostHTTPSPort`​ 时，**SSL 证书是放在内网客户端（本地电脑）上的**，而不是放在 FRP 服务端上。FRP 只负责像「传话筒」一样把加密流量透传过去。

---

### 四、完整配置演示

#### 1. 服务端 `frps.toml`

```toml
bindPort = 7000
vhostHTTPPort = 80      # 开启 HTTP 虚拟主机
vhostHTTPSPort = 443     # 开启 HTTPS 虚拟主机
```

#### 2. 客户端 A（博客） `frpc.toml`

```toml
serverAddr = "x.x.x.x"
serverPort = 7000
[[proxies]]
name = "my-blog"
type = "http"            # 注意这里是 http
localIP = "127.0.0.1"
localPort = 8080
customDomains = ["blog.example.com"]
```

#### 3. 客户端 B（导航页，带HTTPS） `frpc.toml`

```toml
serverAddr = "x.x.x.x"
serverPort = 7000
[[proxies]]
name = "my-nav"
type = "https"           # 注意这里是 https
localIP = "127.0.0.1"
localPort = 443          # 本地机器要自己跑 HTTPS
customDomains = ["nav.example.com"]
```

---

### 五、总结

- 如果你只是想远程桌面（SSH）、连数据库（MySQL），**不需要配置这两个**，用普通的 TCP 端口映射（`remotePort`）即可。
- 如果你要穿透 **Web 网站**，且希望通过**域名**来访问，**必须配置这两个**，这是 FRP 做 Web 穿透最优雅的方式。
