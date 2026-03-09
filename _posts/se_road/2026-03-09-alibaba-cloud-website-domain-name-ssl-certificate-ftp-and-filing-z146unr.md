---
title: 阿里云网站、域名、SSL证书、FTP及备案
date: '2026-03-06 11:01:14'
permalink: >-
  /post/alibaba-cloud-website-domain-name-ssl-certificate-ftp-and-filing-z146unr.html
tags:
  - aliyun｜阿里云
  - operation｜运维
categories:
  - Software Development｜软件开发
layout: post
published: true
---



## 摘要

### 本次研究学习的路径（按需深入）：

阿里云提交备案申请->（需要）实例关联域名->（需要）域名关联SSL证书->（需要）购买及申请证书->宝塔面板部署域名及SSL证书（自动创建域名及SSL相关nginx配置）->修改nginx配置（避免默认配置对80端口的影响）->IP访问成功->配置域名解析->域名访问成功->通过宝塔面板部署博客静态文件->（在阿里云，实例关联域名）->调通FTP服务（便于后续更新博客）

## 检查并调试nginx #nginx#

### 检查nginx的运行状态

```bash
ps aux | grep nginx
```

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306142853-bjm1pcr.png)确认nginx监听的端口

```bash
sudo ss -tulpn | grep nginx
```

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306144637-0d660w2.png)

### nginx通过宝塔面板安装位置

**执行文件**

```bash
/etc/init.d/nginx

#重启
/etc/init.d/nginx reload
#启动
/etc/init.d/nginx start
#停止
/etc/init.d/nginx stop
```

### systemctl的nginx与usr下的nginx差别

systemctl的nginx在`/etc/init.d/nginx`，这个是脚本。

bash直接执行的nginx，在`/usr/bin/nginx/nginx`，这个是二进制文件。

**Nginx 主配置文件**

```bash
/www/server/nginx/conf/nginx.conf

# 测试配置文件语法
nginx -t
```

**虚拟主机/站点配置文件**

每个网站（包括默认站点、SSL配置、重写规则等）都有独立的配置文件在这里。

例如：

- ​`/www/server/panel/vhost/nginx/example.com.conf`
- ​`/www/server/panel/vhost/nginx/0_default.conf`（默认站点）

```bash
/www/server/panel/vhost/nginx/*.conf
```

**重写规则目录**

```bash
/www/server/panel/rewrite/
```

每个程序的伪静态规则存放在这里，如：

- ​`/www/server/panel/rewrite/nginx/wordpress.conf`
- ​`/www/server/panel/rewrite/nginx/thinkphp.conf`

**SSL证书目录**

```bash
/www/server/panel/ssl/
```

**日志文件位置**

```bash
/www/wwwlogs/
```

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306150917-w6xi1nr.png)

## 数字证书购买、申请及部署

### 购买

> 实际是购买用于验证的服务器

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306173630-92so924.png)

购买个人测试证书（每个账号可免费买20个）

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306173730-qshlcgd.png)

### 申请证书

> 购买验证服务器后，需要申请证书才能生效

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306173915-e4l872n.png)

选择“待申请”的进行申请证书

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306174116-pw7gylh.png)

申请通过后，下载

## 部署

### 通过宝塔面板部署

通过以下界面操作，实际对对以下文件进行了新增和修改

```bash
# 新增含SSL认证的nginx conf文件
/www/server/panel/vhost/nginx/www.chenxie.fun.conf
# 监听了80和443端口，配置了日志记录位置，SSL证书位置

# 证书位置
ssl_certificate    		/www/server/panel/vhost/cert/www.chenxie.fun/fullchain.pem;
ssl_certificate_key    	/www/server/panel/vhost/cert/www.chenxie.fun/privkey.pem;
```

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306174702-54qlr35.png)

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306174801-ywnstpq.png)

### 访问IP地址验证

此时，显示`不安全`​，没有关系，因为域名的SSL证书和IP地址的证书不同，我们使用的域名证书，不是IP地址证书，所以会报`不安全`

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306175229-ph8jop4.png)

### 配置域名解析

​`A`​是解析`IP地址`​，`CNAME`​是解析`其他域名`；

比如映射到github的page服务，就是记录类型：`CNAME`​ 记录值：`neilchenxie.github.io`

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260306175528-s9w1m2u.png)

然后访问`chenxie.fun`域名应该就能访问到该页面，且SSL已生效。

## FTP设置

核心是在服务器端，要修改FTP服务器的`PassiveMode`​、`ForcePassiveIP`​、`PassiveMode`​配置，并开放21端口及`PassivePortRange`指定的端口。

### 开放端口

1、端口21

2、与FTP服务器端设置的`PassivePortRange`相关

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260309112551-x2d7jyd.png)

### PureFTPd设置

通过宝塔面板安装的PureFTPd，实际安装位置

```bash
# 安装位置
/www/server/pure-ftpd/

# 配置文件
/www/server/pure-ftpd/etc/pure-ftpd.conf
```

通过宝塔安装的FTP服务PureFTPd的设置路径：

- 登录您**宝塔面板**。
- 在左侧菜单栏找到并进入 ​ **“软件商店”** 。
- 在“已安装”列表中找到 ​ **“Pure-Ftpd”** ​，点击右侧的 ​ **“设置”** 。
- 在设置窗口中，切换到  **“配置修改”**  选项卡。
- 找到或添加以下关键参数（如果不存在就手动添加）：

```bash
# 启用被动模式
PassivePortRange          50000 51000
# ！！！最重要的一行：指定服务器公网IP
ForcePassiveIP            8.148.185.181
# 以下两行通常默认存在，确保是YES
PassiveMode               yes
```

(`PassivePortRange 39000 40000`可保持不变)

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260309104425-atyunep.png)

### FileZilla

如果仅开放了`21`​端口，但是没有改变**PureFTPd**的设置以及开放`39000/40000`端口，会出现问题：

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260309142800-hu9o2zq.png)

#### 无法删除非空文件夹

- 在宝塔面板的  **"文件"**  管理器中：
- 找到`/www/wwwroot/www.chenxie.fun`目录
- 右键点击或选中后点击  **"权限"**  按钮
- 将权限设置为：

  - ​**所有者**​：通常设置为 `www`（或其他Web服务器用户）
  - ​**权限**​：建议设置为 `755`​（目录）和 `644`（文件）
  - **勾选** "递归设置" 选项
- 点击确定，然后通过FTP再次尝试删除
