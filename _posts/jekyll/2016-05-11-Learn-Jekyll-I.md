---
layout: post
title: 安装Jekyll
date: 2016-05-11 9:30:15 +0800
category: ChenBlog
tags: [jekyll, tutorial]
---

选择Jekyll，因为GitHub Page直接支持Jekyll，不用像Hexo要提前编译成HTML

Jekyll 是基于Ruby的，所以需要先安装相关环境，教程见官方文档，Google和百度

以下是几个需要了解的概念及关系

## RVM

对于Debian系的Linux，自带Ruby版本有问题，需要通过RVM管理Ruby版本
其他环境也可以用RVM管理Ruby，与系统**独立**开

[RVM中文安装教程](https://ruby-china.org/wiki/rvm-guide)

[RVM官网](https://rvm.io/)

### BUG

`rvm is not a function`

> `bash --login`

## GEM

gem install

> gem管理工具, \*.gem 是Ruby包文件扩展名

[官网](https://rubygems.org/)

## Bundle

项目管理工具，与Java的Maven，Node.js的npm类似。

[官网](http://bundler.io/)
