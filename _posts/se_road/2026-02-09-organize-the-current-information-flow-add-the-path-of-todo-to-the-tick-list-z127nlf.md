---
title: 整理目前的信息流；增加Todo到滴答清单的路径
date: '2026-02-09 11:01:37'
permalink: >-
  /post/organize-the-current-information-flow-add-the-path-of-todo-to-the-tick-list-z127nlf.html
tags:
  - digital_mind｜电子大脑
  - road_map｜路线图
categories:
  - Software Development｜软件开发
layout: post
published: true
---



## 摘要

### 更新日期

2026年2月9日

### 最新路线图

![](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/excalidraw-image-20260209095322-iscy782.svg)

### 产品日志

- 增加Todo到滴答清单的路径
- 保持了「Todo&Collect｜代办与收藏」的跨平台通用性
- 优化Reminder Tag的增删方法
- 增加ToDo到家庭清单（shared）的办法

### 开发日志

#### Modify Tags of Reminders

用`Edit Reminder`​中的`remove Tags`方法替换之前的字符串操作

之前的字符串操作：

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260209151624-xefnmxl.png)

​`Edit Reminder`操作

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260209151700-rqpf5yi.png)

#### Set Due Date of Reminders

需要用以下方式，先创建，在用`Edit Reminder`​来`Set Due Date`，直接在Alert那设置变量会报错。

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260209160446-p4mfswa.png)
