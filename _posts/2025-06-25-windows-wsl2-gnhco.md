---
title: Windows WSL2
date: '2025-06-25 08:39:07'
permalink: /post/windows-wsl2-gnhco.html
tags:
  - docker
  - wsl2
categories:
  - Software Development｜软件开发
layout: post
published: true
---





# 摘要

- 后续的Docker等程序，都需要WSL2环境，如果WSL环境安装不正确（或不是最新版本），会导致后续软件安装失败。
- 参考链接：[https://www.bilibili.com/video/BV1THKyzBER6](https://www.bilibili.com/video/BV1THKyzBER6)

## 安装步骤

1. ### 修改Windows的默认设置

    1. ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20250708225104-3xs1d2y.png)
    2. 启用“虚拟机平台”（Virtual Machine Platform）和“适用于Linux的Windows子系统”

        ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20250708225129-jiivqrs.png)

        ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20250708225253-bsm41wk.png)
    3. 按照提示重新启动电脑
2. ### 通过`cmd`​或者`powershell`安装WSL

    - ```bash
      #将WSL的版本设置为WSL2
      wsl --set-default-version 2

      #更新WSL
      wsl --update
      #如果下载太慢，尝试 
      wsl --update --web-download
      #或者从github下载离线安装包：https://github.com/microsoft/WSL/releases
      ```

# 详细记录
