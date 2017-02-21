---
title: Systemd & Systemctl
date: 2017-02-21 10:54:45 +0800
category: Linux
tags: [linux, linux-tool]
---

在红帽企业版Linux 7版本以前的系统中，init是不可或缺的进程之一。所谓init进程，是一个由内核启动的用户级进程，其ID进程编号始终是1。这一进程负责激活系统中的其他服务，较为常用的守护进程在系统启动时通过shell脚本启动，而不常用的守护进程由其他服务根据需要来启动。因此，许多年来init始终是Linux和UNIX系统的第一个进程。

RHEL 7和CentOS 7中最重要的一个变化就来自systemd，它用于取代红帽企业版Linux 7版本以前的init系统。在RHEL 7中，进程ID=1属于systemd这一新的初始化进程。下面我们一起来学习和掌握systemd进程及systemctl工具。

### 1 Systemd

> [《RHEL7专题系列》之systemctl控制系统服务](http://mp.weixin.qq.com/s/hTOwRVqj97ysonh9z4bshg), [CoreOS实践指南（三）：系统服务管家Systemd](http://www.csdn.net/article/2015-01-08/2823477/1)

**systemd是一种新的Linux管理系统和服务的进程，它可以在系统启动时和运行时激活系统资源、服务器守护进程和其他进程。** 在RHEL 7中systemd取代了init系统，成为新的默认初始化系统，用systemd初始化工具来启动系统，优势在于并发读取、管理服务。

它主要的设计目标是克服传统Linux主流启动程序SysVinit 固有的缺点，提高系统的启动速度。

> systemd能够管理系统的启动进程和一些系统服务，一旦系统启动，就将监管整个系统。systemd这一名字源于UNIX中的一个惯例：在UNIX中常以'd'作为系统守护进程(daemon，亦称后台进程)的后缀标识，守护进程是在执行各种任务的后台等待或运行的进程，一般情况下，守护进程在系统启动时自动启动并持续运行至关机或被手动停止。

注意：为了软件的向下兼容，旧有的service命令在CentOS 7中仍然可用，会重定向所有service命令到新的systemctl工具。

#### 1.1 基础概念-Unit

> [Systemd 日常使用介绍](http://www.jianshu.com/p/a35b2608ffb2)。后续有 **详解章节**。

Systemd将系统初始化过程中所有的操作步骤都被抽象为Unit 对应于之前SysVinit时代的Daemon的超集 ，根据不同的操作内容，Unit被细分为多个分类：

* service ：类似于SysVinit时代的Daemon，代表一个后台服务进程，比如 mysqld。这是最常用的一类。
* target ：Unit组。此类配置单元为其他配置单元进行逻辑分组。它们本身实际上并不做什么，只是引用其他配置单元而已。这样便可以对配置单元做一个统一的控制。这样就可以实现大家都已经非常熟悉的运行级别概念。比如想让系统进入图形化模式，需要运行许多服务和配置命令，这些操作都由一个个的配置单元表示，将所有这些配置单元组合为一个目标(target)，就表示需要将这些配置单元全部执行一遍以便进入目标所代表的系统运行状态。 (例如：multi-user.target 相当于在传统使用 SysV 的系统中运行级别 5)

**其他Unit**

* timer：定时器配置单元用来定时触发用户定义的操作，这类配置单元取代了 atd、crond 等传统的定时服务。
* snapshot ：与 target 配置单元相似，快照是一组配置单元。它保存了系统当前的运行状态。
* socket ：此类配置单元封装系统和互联网中的一个 套接字 。当下，systemd 支持流式、数据报和连续包的 AF_INET、AF_INET6、AF_UNIX socket 。每一个套接字配置单元都有一个相应的服务配置单元 。相应的服务在第一个"连接"进入套接字时就会启动(例如：nscd.socket 在有新连接后便启动 nscd.service)。
* device ：此类配置单元封装一个存在于 Linux 设备树中的设备。每一个使用 udev 规则标记的设备都将会在 systemd 中作为一个设备配置单元出现。
* mount ：此类配置单元封装文件系统结构层次中的一个挂载点。Systemd 将对这个挂载点进行监控和管理。比如可以在启动时自动将其挂载；可以在某些条件下自动卸载。Systemd 会将/etc/fstab 中的条目都转换为挂载点，并在开机时处理。
* automount ：此类配置单元封装系统结构层次中的一个自挂载点。每一个自挂载配置单元对应一个挂载配置单元 ，当该自动挂载点被访问时，systemd 执行挂载点中定义的挂载行为。
* swap: 和挂载配置单元类似，交换配置单元用来管理交换分区。用户可以用交换配置单元来定义系统中的交换分区，可以让这些交换分区在启动时被激活。

#### 1.2 相关目录和文件

> [Systemd 日常使用介绍](http://www.jianshu.com/p/a35b2608ffb2)

* /etc/systemd/ 开机启动的unit配置文件们，一般都是符号连接到/lib/systemd/
* /lib/systemd/ 所有的unit配置文件们

#### 1.3 Systemd优点

> [Systemd 日常使用介绍](http://www.jianshu.com/p/a35b2608ffb2)

* 尽可能懒加载
* 尽可能并行
* 解决Unit依赖关系
* 采用 Cgroup 跟踪和管理进程的生命周期
* 统一管理日志

**1 提高并发启动能力，加快了系统启动时间**

**2 按需启动服务**

> Systemd 可以提供按需启动的能力，只有在某个服务被真正请求的时候才启动它。当该服务结束，systemd 可以关闭它，等待下次需要时再次启动它。

**3 System解决Unit依赖和事物处理**

> 每个Unit的配置文件都会指定其运行所需的依赖关系（Unit配置文件中[Unit]字段描述），依赖关系有两种：
> * Requires 强依赖，依赖的Unit如果不能正常启动，则配置的这个Unit也启动失败
> * Wants 弱依赖，依赖的Unit如果不能正常启动，则不影响这个Unit的启动;Unit一旦形成循环依赖，systemd 将尝试去掉 wants 关键字指定的依赖看看是否能打破循环。如果无法修复，systemd 会报错：


### 2 Systemctl

**监视控制systemd的主要工具是systemctl** 。systemctl向systemd发送命令，可用于查看系统状态和管理系统、服务。systemctl用于管理各种类型的systemd对象，称为单元。

具体 **使用详解** 可阅读 [《RHEL7专题系列》之systemctl控制系统服务](http://mp.weixin.qq.com/s/hTOwRVqj97ysonh9z4bshg)

### 3 Unit文件详解

> [CoreOS实践指南（八）：Unit文件详解](http://www.csdn.net/article/2015-02-27/2824034)

### 3 Reference

* [《RHEL7专题系列》之systemctl控制系统服务](http://mp.weixin.qq.com/s/hTOwRVqj97ysonh9z4bshg)
* [Systemd 日常使用介绍](http://www.jianshu.com/p/a35b2608ffb2)
* [CoreOS实践指南（三）：系统服务管家Systemd](http://www.csdn.net/article/2015-01-08/2823477/1)
* [CoreOS实践指南（八）：Unit文件详解](http://www.csdn.net/article/2015-02-27/2824034)
* [鸟哥的Linux 私房菜-- 第十七章、认识系统服务(daemons)]()
