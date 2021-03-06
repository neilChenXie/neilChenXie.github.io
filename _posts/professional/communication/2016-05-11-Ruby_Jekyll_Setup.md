---
title: Ruby环境及Jekyll安装
date: 2016-05-11 9:30:15 +0800
category: communication
tags: [communication, jekyll, ruby]
---

选择Jekyll，因为GitHub Page直接支持Jekyll，不用像Hexo要提前编译成HTML

Jekyll 是基于Ruby的，所以需要先安装相关环境，教程见官方文档，Google和百度

以下是几个需要了解的概念及关系

### RVM

对于Debian系的Linux，自带Ruby版本有问题，需要通过RVM管理Ruby版本
其他环境也可以用RVM管理Ruby，与系统**独立**开

[RVM中文安装教程](https://ruby-china.org/wiki/rvm-guide)

[RVM官网](https://rvm.io/)

#### BUG

`rvm is not a function`

**solution:**

```
bash --login
```

### GEM

#### \*.gem

\*.gem 是Ruby包文件扩展名。

#### `gem`

> gem管理工具,通过`gem install {pkgName}` 安装gem包,在安装ruby时已经一同安装。


[官网](https://rubygems.org/)

### Bundle

项目管理工具，与Java的Maven，Node.js的npm类似。

#### setup

> need `gem` installed

```ruby
gem install bundler
```

#### Gemfile & Gemfile.lock

`bundle` 依赖于Gemfile找到所需的gem包，并生成Gemfile.lock。不同环境下，先删除Gemfile.lock,运行`bundle install`生成新的.

```bash
# 在项目（博客模版）文件夹下运行
bundle install
```

[官网](http://bundler.io/)

### 安装 Jekyll

```bash
gem install jekyll
```

### 检查安装版本

```bash
ruby -v
jekyll -v
```

### Github & Jekyll

#### {username}.github.io

直接推送master分支即可，有自主域名的话，根目录下添加CNAME文件.

#### 已存在项目

* [Official](https://help.github.com/articles/creating-project-pages-manually/)

创建新分支

```bash
git checkout --orphan gh-pages
```

第一次push

```bash
git push --set-upstream origin gh-pages
```
