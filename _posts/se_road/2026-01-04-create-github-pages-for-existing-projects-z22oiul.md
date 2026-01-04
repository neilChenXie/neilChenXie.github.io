---
title: 已有项目创建Github Pages
date: '2026-01-04 10:55:08'
permalink: /post/create-github-pages-for-existing-projects-z22oiul.html
tags:
  - github
  - jekyll
categories:
  - Software Development｜软件开发
layout: post
published: true
---



# 已有项目创建Github Pages

## 思路

通过`jekyll new myblog`生成必要的文件，再将这些文件Copy到现有项目的指定分支下。

然后配置Github仓库的pages设置、项目CNAME文件、域名供应商的解析。

## 步骤

### 一、新建jekyll博客必要文件

1. ​`jekyll new myblog`

   如果卡住了，直接`Ctrl+c`​，进入目录，运行`bundle install`安装必要的Ruby包。
2. 运行`Jekyll serve`，验证是否正常编译
3. 访问`localhost:4000`验证可正常访问

### 二、将文件Copy到对应项目下

### 三、Github仓库配置

#### 配置Github Actions

**启用项目的 GitHub Pages**：进入你的项目仓库，点击 **Settings** 选项卡。向下滚动找到 **Pages** 部分，在 **Source** 下选择一个分支（通常是 `main`​或 `gh-pages`​）后点击 **Save**。完成后，你就可以通过 `https://<username>.github.io/<projectname>`这个地址访问这个站点了。

使用Github Actions是更主流的方法

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104145439-u9uhmth.png)

Github有默认的Jekyll部署配置文件，实质是在项目下增加`.github/workflows/jekyll-gh-pages.yml`文件

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104150608-869n1n5.png)

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104150745-hzswk4g.png)

配置文件中，只需要注意编译的分支名字

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104150931-z27xap9.png)

#### Github Action编译Debug

相关编译与部署信息可在项目的`Actions`标签页看到详情。

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104152407-w8qxi3r.png)

### 四、项目文件变更

在项目目录下增加CNAME文件。

注意因为第三步直接在Github网站增加了`.github/workflows/jekyll-gh-pages.yml`文件，所以，先执行git pull，再执行git add、git commit、git push。

CNAME文件中，只能写一个域名，不用http、www开头，即与阿里云等网站买的域名一致。

比如我的域名就是chenxie.cc

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104152244-nnc13fq.png)

### 五、域名提供商配置

以阿里云为例，进入`域名与网站`工作台。（本教程不讲域名购买）

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104151521-uciote3.png)

选择要使用的域名，点击进去，选择域名解析

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104151609-fiq4ric.png)

增加`@`​和`www`​两条记录，注意记录值无论是哪个Github项目，都填`<username>.github.io`

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104151833-qbsqmxo.png)
