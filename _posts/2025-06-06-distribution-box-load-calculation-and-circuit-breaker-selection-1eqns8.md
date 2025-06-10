---
title: 配电箱负载计算及断路器选择
date: '2025-06-06 09:38:57'
permalink: >-
  /post/distribution-box-load-calculation-and-circuit-breaker-selection-1eqns8.html
tags:
  - design｜设计
  - electrical engineering｜电气工程
categories:
  - Work｜工作
layout: post
published: true
---



# 配电箱负载计算及断路器选择

# 摘要

- [工业与民用供配电设计手册第四版.pdf](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf)

  - [工业与民用供配电设计手册第四版.pdf - p51 - 1.6 单相负荷计算](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=51)
  - [工业与民用供配电设计手册第四版.pdf - p116 - 2.5 低压配电系统](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=116)
- 单相用电设备应均衡分配到三相上，使各相的计算负荷尽量相近，减小不平衡度。

  - 如果相间负荷差异太大，会导致“零点偏移”，从而让零线（N）带较大电流。
  - [三相电压不平衡时数显电笔测量的结果是怎样的呢？](https://www.bilibili.com/video/BV1NC411L7Nc)
  - [三相电没零线也能通电？三相发电交流发电机工作原理，三相电为什么是380V，星形接法三角形接法](https://www.bilibili.com/video/BV1Eu41117Ji)
  - [电机总是自己停，为啥啊？](https://www.bilibili.com/video/BV1MZ421t7Lk)
- **单相输入（220V）、单相输出（220V）：** 输出端负载，决定了线宽、断路器的选择（假设负载为1kW）

  - ![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250606105501-uu8t34w.png)​
- **三相输入（380V）** 、**单相输出（220V）** （假设负载为1kW）：

  - 1、算出三相，每一相的负载功率
  - 2、取单相中最大的负载功率P<sub>单相max</sub>=<span data-type="text" style="color: var(--b3-font-color13);">Max（∑P</span><sub>单相A</sub><span data-type="text" style="color: var(--b3-font-color13);">，∑P</span><sub>单相B</sub><span data-type="text" style="color: var(--b3-font-color13);">，∑P</span><sub>单相C</sub><span data-type="text" style="color: var(--b3-font-color13);">）</span>；乘以3，转换到3相功率。
  - 3、如果电路中有三相负载，将其功率相加。P<sub>三相</sub>=∑P<sub>每个三相负载</sub>
  - 4、配电箱总负载（输入端需满足负载）<span data-type="text" style="color: var(--b3-font-color13);">P</span><sub>j</sub>=P<sub>三相</sub>+<span data-type="text" style="color: var(--b3-font-color13);">3×</span>P<sub>单相max</sub>
  - 5、输入电流<span data-type="text" style="color: var(--b3-font-color13);">I</span><sub>j</sub>=P<sub>j</sub>/(√3×380×<span data-type="text" style="color: var(--b3-font-color13);">0.8</span>），0.8为功率系数cosΦ的常规取值；<span data-type="text" style="color: var(--b3-font-color13);">断路器电流选择＞1.25×I</span><sub>j</sub>
- **断路器选择**

  - 单相 I<sub>断路器</sub>＞1.1×单相负载电流
  - 输入I<sub>断路器</sub>＞<span data-type="text" style="color: var(--b3-font-color13);">1.25×I</span><sub>j</sub>
- **参考资料**

  - [如何读懂设计院电气图纸——配电箱负荷计算](https://www.bilibili.com/video/BV1Bw411H7Bz)
  - [建筑电气中的配电箱系统设计](https://www.bilibili.com/video/BV1nV411o7rQ)

# 详细记录

‍
