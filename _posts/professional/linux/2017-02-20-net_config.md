---
title: Linux(CentOS 7)网络配置
date: 2016-07-21 16:20:15 +0800
category: Linux
tags: [linux, linux-config]
---

> CentOS 7

### 配置位置

`/etc/hosts`

> 本机配置DNS

`/etc/hostname`

> 本机名字

`/etc/resolv.conf`

> DNS Server IP

`/etc/sysconfig/network-scripts/ifcfg-{name}`

> 连接配置的脚本,DNS参数会同步到`/etc/resolv.conf`中

### 代理

`/etc/profile`

> 实际是增加一个全局变量

```bash
http_proxy="{httpServer:port}"
export http_proxy
```
