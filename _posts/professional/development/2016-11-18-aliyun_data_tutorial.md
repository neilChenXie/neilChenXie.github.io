---
title: 阿里云数加平台-推荐引擎
date: 2016-11-18 9:30:15 +0800
category: development
tags: [development, recommand system, tutorial]
---

> 阿里云数加平台的推荐服务，提供了一个算法实验的平台，不用自己搭建大数据平台。

### 1 环境及组件


1. 开通**[数加平台](https://data.aliyun.com/console)**

	> 阿里云大数据平台

2. 购买**[推荐服务](https://data.aliyun.com/buy/re)**

	> 大数据平台下的推荐引擎服务

3. 开通**[数据计算服务](https://data.aliyun.com/console/data)**

	> 推荐引擎所需的计算资源

4. 下载配置[客户端](https://help.aliyun.com/document_detail/27971.html)

	> 传输数据的命令行客户端

5. 开通[大数据开发套件](https://ide.shuju.aliyun.com/?Lang=zh_CN)

	> **查看**数据，**增删改**都可以通过客户端操作

### 2 实验

> [实验官方文档](https://help.aliyun.com/document_detail/32458.html)

#### 2.1 数据开发-项目

这里**项目**相当于一个命名空间。

* 所有**数据**都会在**一个项目**下,相当于**数据库**。
* **云计算资源**也必须属于**一个项目**。
* **推荐业务**选择了**计算资源**，也就选择了**数据库**。
* **客户端**连接时也是配置**项目**

> [数据开发-项目管理](https://data.aliyun.com/console/data)

> [官方**创建项目**文档](https://help.aliyun.com/document_detail/27815.html)

#### 2.2 云计算资源

在项目下创建计算资源。

> [推荐引擎-资源管理](https://dtboost.shuju.aliyun.com/re#/storage)

#### 2.3 我的推荐-业务

在项目下创建推荐业务

> [推荐引擎-我的推荐](https://dtboost.shuju.aliyun.com/re#/myre)

### 3 实验注意事项

官方文档整体很清晰，其中有几个注意要点：

\* [数据格式转化和加载](https://help.aliyun.com/document_detail/32462.html#h2-4-)中**partition**参数与**日期**相关，在[启动预处理](https://help.aliyun.com/document_detail/32465.html#h2-1-)时与选择的**日期**要一致。

> 而预处理时间选择是**近三个月**，所以例子中的20160401选不了，改为最近某天即可。

### 4 扩展阅读

* [MaxCompute官方文档](https://help.aliyun.com/document_detail/27800.html)
