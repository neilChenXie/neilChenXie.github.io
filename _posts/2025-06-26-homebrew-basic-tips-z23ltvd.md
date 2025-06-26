---
title: Homebrew基本技巧
date: '2025-06-26 10:02:19'
permalink: /post/homebrew-basic-tips-z23ltvd.html
tags:
  - MacOS
  - shell｜脚本
categories:
  - Software Development｜软件开发
layout: post
published: true
---





# 摘要

- 简介：Mac的包管理器，类似Ubuntu的apt。
- 官网：[https://brew.sh/](https://brew.sh/)
- 安装：遵循官网
- 更新源：官方源，可能因为墙的问题，导致链接不稳定，且速度慢

  - [清华大学源](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)
  - [中科大源](https://mirrors.ustc.edu.cn/help/brew.git.html)
- 常用命令

  - ```bash
    #更新Homebrew自身
    brew update

    #更新通过Homebrew安装的包
    brew upgrade

    #brew查询包是否存在、版本等信息
    brew info [packageName]

    #搜索包Homebrew（包的名字记不清）
    brew search [packageName]

    #包安装
    brew install [packageName]
    ```

# 详细记录
