---
title: CentOS 7 装机
date: 2016-06-05 11:16:15 +0800
category: Linux
tags: [linux, linux-config]
---

## Setup

For centos **7**

### Compatible with windows

Install ntfs-3g

```bash
# or yum search epel
wget https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
rpm -ivUh epel-release-7-5.noarch.rpm

yum install ntfs-3g
```

system bootup recovery

```bash
grub2-mkconfig -o /boot/grub2/grub.cfg
```

## Feature

* package: yum and rpm
