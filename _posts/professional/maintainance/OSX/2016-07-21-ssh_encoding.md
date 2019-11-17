---
title: ssh 登录乱码
date: 2016-07-21 09:16:15 +0800
category: OSX
tags: [osx,linux]
---

### 问题

当OSX Terminal ssh登录 CentOS时 出现 `warning`:

```bash
-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
```

### 原因

OSX Terminal 用 UTF-8 编码，而且ssh连接时会试图将远程编码设为UTF-8
(等价代码
`export LC_CTYPE=UTF-8`)。
但是，一些系统,如 CentOS 7，不支持UTF-8。

```bash
# 查询系统支持的编码
locale -a

# 查询当前使用编码
echo "$LC_CTYPE"
```

### 解决

编辑 /etc/ssh/ssh_config，注释掉`SendEnv`

```bash
#SendEnv LANG LC_*
```
