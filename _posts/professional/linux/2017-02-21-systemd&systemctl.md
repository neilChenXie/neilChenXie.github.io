---
title: Sysvinit, Systemd & Systemctl
date: 2017-02-21 10:54:45 +0800
category: Linux
tags: [linux, linux-tool]
---

## 起因

&nbsp;&nbsp;&nbsp;&nbsp;此次研究的起因是，希望能够配置一个程序开机启动，但网上的教程十分杂乱，脚本和代码都没有写明原理。虽然最后通过**service**命令成功配置，但是在centos7中，shell打印` (via systemctl)`，说明systemctl实际替代了service嘛。于是层层深挖，挖出了linux整个系统的初始化流程，以及机制的历史发展进程。一下大多数为**摘抄**，最后Reference中列举所有阅读资料。

**阅读要求**： 有接触过`service`，`systemctl`命令，`/etc/init.d/`,`/etc/rc.d/`,`/etc/systemd/system/`等目录下的文件。**或者**，需要 **配置系统自动启动等脚本** 等实际使用需求，可先查看第x章 **实际使用场景**。

## 摘要

&nbsp;&nbsp;&nbsp;&nbsp;近年来，Linux 系统的 **init 进程** 经历了两次重大的演进，传统的 **sysvinit** 已经淡出历史舞台，新的 init 系统 **UpStart** 和 **systemd** 各有特点，而越来越多的 Linux 发行版采纳了 systemd。而 **service** 和 **chkconfig** 是sysvinit的管理工具，**systemctl** 是监视控制systemd的主要工具。**upstart** 因为使用中未接触过，本文未涉及。

## 1 init 进程

&nbsp;&nbsp;&nbsp;&nbsp;在红帽企业版Linux 7版本以前的系统中，init是不可或缺的进程之一。所谓init进程，是一个由内核启动的用户级进程，其ID进程编号始终是1。这一进程负责激活系统中的其他服务，较为常用的守护进程在系统启动时通过shell脚本启动，而不常用的守护进程由其他服务根据需要来启动。因此，许多年来init始终是Linux和UNIX系统的第一个进程。
&nbsp;&nbsp;&nbsp;&nbsp;大多数 Linux 发行版的 init 系统是和 System V 相兼容的，被称为 sysvinit。这是人们最熟悉的 init 系统。Ubuntu 16.04 和 RHEL 7 之前采用 upstart 替代了传统的 sysvinit。而 Fedora 从版本 15 开始使用了一个被称为 systemd 的新 init 系统。另外，一些发行版如 Slackware 采用的是 BSD 风格 Init 系统，这种风格使用较少。其他的发行版如 Gentoo 是自己定制的。
&nbsp;&nbsp;&nbsp;&nbsp;RHEL 7和CentOS 7中最重要的一个变化就来自systemd，它用于取代红帽企业版Linux 7版本以前的init系统。在RHEL 7中，进程ID=1属于systemd这一新的初始化进程。下面我们一起来学习和掌握systemd进程及systemctl工具。

## 2 sysvinit

> 详解见  [鸟哥的Linux 私房菜-- 第十七章、认识系统服务(daemons)](http://linux.vbird.org/linux_basic/0560daemons.php), [浅析 Linux 初始化 init 系统，第 1 部分: sysvinit](https://www.ibm.com/developerworks/cn/linux/1407_liuming_init1/index.html)

### sysvinit简介

sysvinit 就是 system V 风格的 init 系统，顾名思义，它源于 System V 系列 UNIX。它提供了比 BSD 风格 init 系统更高的灵活性。是已经风行了几十年的 UNIX init 系统，一直被各类 Linux 发行版所采用。

系统启动时，sysvinit 需要读取/etc/inittab 文件，来确定运行等级**X**。sysvinit **串行顺序地**执行以下这些步骤，从而将系统初始化为预订的 runlevel **X**。
1. /etc/rc.d/rc.sysinit
2. /etc/rc.d/rc
3. /etc/rc.d/rc**X**.d/ (**X** 代表运行级别 0-6)
4. /etc/rc.d/rc.local
5. X Display Manager（如果需要的话）

而/etc/rc.d/rc**X**.d/下都是linux软链接文件，真实的脚本文件存放在**/etc/init.d** 目录下。文件名以 S 开头的脚本就是启动时应该运行的脚本，S 后面跟的数字定义了这些脚本的执行顺序。

Sysvinit 不仅需要负责初始化系统，还需要负责**关闭系统**。这种顺序的控制这也是依靠/etc/rc.d/rc**X**.d/目录下所有脚本的命名规则来控制的，在该目录下所有以 K 开头的脚本都将在关闭系统时调用，字母 K 之后的数字定义了它们的执行顺序。这些脚本负责安全地停止服务或者其他的关闭工作。

基于sysvinit提供的常见的shell命令有：
* reboot：等于 shutdown –r 或者 telinit 6。重启系统。
* shutdown：以一种安全的方式终止系统，所有正在登录的用户都会收到系统将要终止通知，并且不准新的登录。
* halt：停止系统。

### service & chkconfig

不同的 Linux 发行版在这些 sysvinit 的基本工具基础上又开发了一些辅助工具用来简化 init 系统的管理工作。**service** 和 **chkconfig** 就是最流行常见的两个。

### Sysvinit 的小结

&nbsp;&nbsp;&nbsp;&nbsp;Sysvinit 的优点是概念简单。Service 开发人员只需要编写启动和停止脚本，概念非常清楚；将 service 添加/删除到某个 runlevel 时，只需要执行一些创建/删除软连接文件的基本操作；这些都不需要学习额外的知识或特殊的定义语法(UpStart 和 Systemd 都需要用户学习新的定义系统初始化行为的语言)。
&nbsp;&nbsp;&nbsp;&nbsp;其次，sysvinit 的另一个重要优点是确定的执行顺序：脚本严格按照启动数字的大小顺序执行，一个执行完毕再执行下一个，这非常有益于错误排查。UpStart 和 systemd 支持并发启动，导致没有人可以确定地了解具体的启动顺序，排错不易。
&nbsp;&nbsp;&nbsp;&nbsp;但是串行地执行脚本导致 sysvinit 运行效率较慢，在新的 IT 环境下，启动快慢成为一个重要问题。此外动态设备加载等 Linux 新特性也暴露出 sysvinit 设计的一些问题。针对这些问题，人们开始想办法改进 sysvinit，以便加快启动时间，并解决 sysvinit 自身的设计问题。

## 2 Systemd

> 详解见 [浅析 Linux 初始化 init 系统，第 3 部分: Systemd](https://www.ibm.com/developerworks/cn/linux/1407_liuming_init3/index.html), [《RHEL7专题系列》之systemctl控制系统服务](http://mp.weixin.qq.com/s/hTOwRVqj97ysonh9z4bshg), [CoreOS实践指南（三）：系统服务管家Systemd](http://www.csdn.net/article/2015-01-08/2823477/1)

&nbsp;&nbsp;&nbsp;&nbsp;Systemd 的很多概念来源于苹果 Mac OS 操作系统上的 launchd，不过 launchd 专用于苹果系统，因此长期未能获得应有的广泛关注。

&nbsp;&nbsp;&nbsp;&nbsp;systemd 引入了新的配置方式，对应用程序的开发也有一些新的要求。如果 systemd 想替代目前正在运行的初始化系统，就必须和现有程序兼容。任何一个 Linux 发行版都很难为了采用 systemd 而在短时间内将所有的服务代码都修改一遍。Systemd 提供了和 Sysvinit 以及 LSB initscripts 兼容的特性。系统中已经存在的服务和进程无需修改。这降低了系统向 systemd 迁移的成本，使得 systemd 替换现有初始化系统成为可能。

&nbsp;&nbsp;&nbsp;&nbsp;**systemd是一种新的Linux管理系统和服务的进程，它可以在系统启动时和运行时激活系统资源、服务器守护进程和其他进程。** 在RHEL 7中systemd取代了init系统，成为新的默认初始化系统，用systemd初始化工具来启动系统，优势在于并发读取、管理服务。

&nbsp;&nbsp;&nbsp;&nbsp;它主要的设计目标是克服传统Linux主流启动程序SysVinit 固有的缺点，提高系统的启动速度。

> systemd能够管理系统的启动进程和一些系统服务，一旦系统启动，就将监管整个系统。systemd这一名字源于UNIX中的一个惯例：在UNIX中常以'd'作为系统守护进程(daemon，亦称后台进程)的后缀标识，守护进程是在执行各种任务的后台等待或运行的进程，一般情况下，守护进程在系统启动时自动启动并持续运行至关机或被手动停止。

&nbsp;&nbsp;&nbsp;&nbsp;注意：为了软件的向下兼容，旧有的service命令在CentOS 7中仍然可用，会重定向所有service命令到新的systemctl工具。

### 1.1 基础概念-Unit

> [Systemd 日常使用介绍](http://www.jianshu.com/p/a35b2608ffb2)。后续有 **详解章节**。

&nbsp;&nbsp;&nbsp;&nbsp;系统初始化需要做的事情非常多。需要启动后台服务，比如启动 SSHD 服务；需要做配置工作，比如挂载文件系统。这个过程中的每一步都被 systemd 抽象为一个配置单元，即 unit，**对应于之前SysVinit时代的Daemon（守护进程）的超集**。可以认为一个服务是一个配置单元；一个挂载点是一个配置单元；一个交换分区的配置是一个配置单元等等。

&nbsp;&nbsp;&nbsp;&nbsp;systemd 将配置单元归纳为以下一些不同的类型：

**常见Unit**

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

&nbsp;&nbsp;&nbsp;&nbsp;然而，systemd 正在快速发展，新功能不断增加。所以配置单元类型可能在不久的将来继续增加。

### 1.2 相关目录和文件

> [Systemd 日常使用介绍](http://www.jianshu.com/p/a35b2608ffb2)

* /etc/systemd/ 开机启动的unit配置文件们，一般都是符号连接到/lib/systemd/
* /lib/systemd/ 所有的unit配置文件们

### 1.3 Systemd优点

> [Systemd 日常使用介绍](http://www.jianshu.com/p/a35b2608ffb2)

* 尽可能懒加载（用到才加载）
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


## 2 Systemctl

&nbsp;&nbsp;&nbsp;&nbsp;**监视控制systemd的主要工具是systemctl** 。systemctl向systemd发送命令，可用于查看系统状态和管理系统、服务。systemctl用于管理各种类型的systemd对象，称为单元。

&nbsp;&nbsp;&nbsp;&nbsp;具体 **使用详解** 可阅读 [《RHEL7专题系列》之systemctl控制系统服务](http://mp.weixin.qq.com/s/hTOwRVqj97ysonh9z4bshg)

## 3 Unit文件详解

> [CoreOS实践指南（八）：Unit文件详解](http://www.csdn.net/article/2015-02-27/2824034)



## 5 实际使用场景

### 5.1 开机启动


## 4 Reference

* [《RHEL7专题系列》之systemctl控制系统服务](http://mp.weixin.qq.com/s/hTOwRVqj97ysonh9z4bshg)
* [Systemd 日常使用介绍](http://www.jianshu.com/p/a35b2608ffb2)
* [CoreOS实践指南（三）：系统服务管家Systemd](http://www.csdn.net/article/2015-01-08/2823477/1)
* [CoreOS实践指南（八）：Unit文件详解](http://www.csdn.net/article/2015-02-27/2824034)
* [浅析 Linux 初始化 init 系统，第 1 部分: sysvinit](https://www.ibm.com/developerworks/cn/linux/1407_liuming_init1/index.html)
* [浅析 Linux 初始化 init 系统，第 3 部分: Systemd](https://www.ibm.com/developerworks/cn/linux/1407_liuming_init3/index.html)
* [鸟哥的Linux 私房菜-- 第十七章、认识系统服务(daemons)](http://linux.vbird.org/linux_basic/0560daemons.php)
