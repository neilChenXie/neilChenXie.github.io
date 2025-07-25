---
title: 配电箱浪涌保护
date: '2025-05-22 09:17:36'
permalink: /post/distribution-box-surge-protection-5xif3.html
tags:
  - design｜设计
  - electrical engineering｜电气工程
categories:
  - Work｜工作
layout: post
published: true
---





# 摘要

- 案例图纸

  - ![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250606140545-mgxs2n3.png)
  - 浪涌保护器：PRD-20KA/3P+N
- **为什么要加浪涌保护器**

  - 两个电极之间的电压因雷击或操作过电压而超过点火电压，间隙被击穿，则通过弧光放电释放过电压能量。冲击波过后，由分弧和灭弧室组成的灭弧系统将电弧熄灭，恢复到高阻状态以保护系统。
- **为什么浪涌保护器前面要加断路器（或熔断器）？参数怎么选？**

  - 如果浪涌保护器本身出现故障，将长时间连接（短路接地），导致电源系统短路。此时，前端熔断器（或断路器）需要及时切断接地电路，以确保电路的正常运行。
  - 那么如何区分断路器或熔断器是雷击引起的短路(称为现象A）或者浪涌保护器本身损坏短路(称为现象B)
  - 因为如果A被识别为B，断路器断开时，主电路会烧坏。雷电电流没有充分泄流，导致未让浪涌保护器起到保护电路的作用
  - 如果B被识别为A，主电路会持续短路，导致电路烧坏。
- **断路器参数怎么选？**

  - **必选脱扣曲线**：**D型、K型或延迟型**（避免B/C型）

    - ![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250606145042-dx911m5.png)​
  - **电流**

    - - 最小值： \> SPD最大续流（如T2级选≥100A）；

        - ![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250606145340-3ge2tkn.png)
      - 最大值： ≤上级断路器80%（保证选择性）；
  - **接线**

    - - 铜导线截面积 ≥ **10mm²**（减小感抗）
      - 接线长度 ≤ **0.5m**（降低自感电压降）。
  - **参考链接**

    - [为什么浪涌保护器前面要加熔断器?](https://www.chinahugong.com/news/38.html)
    - [防雷知识连载（三）| SPD的原理和选型](https://www.chenzhu-inst.com/chenzhu-mobile/knowledge/783.html)

      - ![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250606150512-qqkr9s7.png)
      - **什么是工频续流？**

        GDT（气体放电管），属于开关型元件，其开关状态取决于其内部空气是否被击穿。使用开关型元件的SPD称作开关型SPD。开关型，顾名思义，就是工作在“开”和“关”两种状态。

        当电力线上的电压低于其开启电压时，其工作在“开”（高阻）的状态，当电力线电压高于其开启电压时（如电涌产生），其工作在“关”（导通）的状态，可以泄放很大的电流。开关型元件的导通状态通常是气体弧光放电的过程，因为维持弧光放电的电压只需要几十伏（通常低于电力线的额定工作电压），所以在电涌消失后，施加在SPD上的电力线电压使得弧光放电得以维持，这就是工频续流。工频续流会使得在电涌消失后，SPD无法返回到开路（高阻）状态，造成SPD发热甚至炸裂，引发火灾事故。所以开关型SPD一般只用于电源系统N-PE之间（或低压低流的信号系统中），如果要应用在电力线上，其必须具备续流遮断能力。

# 详细记录

‍
