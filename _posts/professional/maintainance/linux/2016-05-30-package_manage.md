---
title: 包管理
date: 2016-05-30 11:16:15 +0800
category: Linux
tags: [linux]
---

`rpm` `yum` `apt-get` 等工具为程序安装提供了方便便捷的方法，但是，散落在各处的文件却不善于被统一管理。

当然，以上问题在工具中有相应的管理命令。

![linux_pkg](https://cloud.githubusercontent.com/assets/5840527/23390869/9eb97f3c-fdab-11e6-89f4-673dea55da38.png)

## 源

### 源列表

* [http://mirrors.aliyun.com/](http://mirrors.aliyun.com/)
* [https://mirror.tuna.tsinghua.edu.cn/](https://mirror.tuna.tsinghua.edu.cn/)


### 位置

| pkt manager | main | app |
| ----------- | ---- | --- |
| apt-get | /etc/apt/source.list |
| yum | /etc/yum.repos.d/ | /etc/yum.repos.d/ |

### 格式

#### apt-get

```bash
# deb {url}/{dist} {version} {component}
# deb-src {url}/{dist} {version} {component}
deb http://mirrors.aliyun.com/ubuntu trusty universe
deb-src http://mirrors.aliyun.com/ubuntu trusty universe
```

version

> * trusty
* trusty-backports
* trusty-proposed (not used)
* trusty-security
* trusty-updates  
