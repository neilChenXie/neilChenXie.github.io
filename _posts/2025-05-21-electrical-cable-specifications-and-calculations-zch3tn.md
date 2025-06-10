---
title: 电气规范及配电箱计算
date: '2025-05-21 17:16:41'
permalink: /post/electrical-cable-specifications-and-calculations-zch3tn.html
tagline: 配电箱负载计算及断路器选择、浪涌保护选择、压降计算、线缆载流量、线缆命名规则
tags:
  - design｜设计
categories:
  - Work｜工作
layout: post
published: true
---



# 电气规范及配电箱计算

# 摘要

- 规范

  - [工业与民用供配电设计手册第四版.pdf](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf)

# 详细记录

## 配电箱负载计算及断路器选择

> - [工业与民用供配电设计手册第四版.pdf](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf)
>
>   - [工业与民用供配电设计手册第四版.pdf - p51 - 1.6 单相负荷计算](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=51)
>   - [工业与民用供配电设计手册第四版.pdf - p116 - 2.5 低压配电系统](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=116)
> - 单相用电设备应均衡分配到三相上，使各相的计算负荷尽量相近，减小不平衡度。
>
>   - 如果相间负荷差异太大，会导致“零点偏移”，从而让零线（N）带较大电流。
>   - [三相电压不平衡时数显电笔测量的结果是怎样的呢？](https://www.bilibili.com/video/BV1NC411L7Nc)
>   - [三相电没零线也能通电？三相发电交流发电机工作原理，三相电为什么是380V，星形接法三角形接法](https://www.bilibili.com/video/BV1Eu41117Ji)
>   - [电机总是自己停，为啥啊？](https://www.bilibili.com/video/BV1MZ421t7Lk)
> - **单相输入（220V）、单相输出（220V）：** 输出端负载，决定了线宽、断路器的选择（假设负载为1kW）
>
>   - ![image](assets/image-20250606105501-uu8t34w.png)​
> - **三相输入（380V）** 、**单相输出（220V）** （假设负载为1kW）：
>
>   - 1、算出三相，每一相的负载功率
>   - 2、取单相中最大的负载功率P<sub>单相max</sub>=<span data-type="text" style="color: var(--b3-font-color13);">Max（∑P</span><sub>单相A</sub><span data-type="text" style="color: var(--b3-font-color13);">，∑P</span><sub>单相B</sub><span data-type="text" style="color: var(--b3-font-color13);">，∑P</span><sub>单相C</sub><span data-type="text" style="color: var(--b3-font-color13);">）</span>；乘以3，转换到3相功率。
>   - 3、如果电路中有三相负载，将其功率相加。P<sub>三相</sub>=∑P<sub>每个三相负载</sub>
>   - 4、配电箱总负载（输入端需满足负载）<span data-type="text" style="color: var(--b3-font-color13);">P</span><sub>j</sub>=P<sub>三相</sub>+<span data-type="text" style="color: var(--b3-font-color13);">3×</span>P<sub>单相max</sub>
>   - 5、输入电流<span data-type="text" style="color: var(--b3-font-color13);">I</span><sub>j</sub>=P<sub>j</sub>/(√3×380×<span data-type="text" style="color: var(--b3-font-color13);">0.8</span>），0.8为功率系数cosΦ的常规取值；<span data-type="text" style="color: var(--b3-font-color13);">断路器电流选择＞1.25×I</span><sub>j</sub>
> - **断路器选择**
>
>   - 单相 I<sub>断路器</sub>＞1.1×单相负载电流
>   - 输入I<sub>断路器</sub>＞<span data-type="text" style="color: var(--b3-font-color13);">1.25×I</span><sub>j</sub>
> - **参考资料**
>
>   - [如何读懂设计院电气图纸——配电箱负荷计算](https://www.bilibili.com/video/BV1Bw411H7Bz)
>   - [建筑电气中的配电箱系统设计](https://www.bilibili.com/video/BV1nV411o7rQ)

## 高压箱变（100\400\800kVA）

> - 闸坡项目图纸：[22S068-SS-DWG-I-DQ-00078箱变电气主接线图.dwg](assets/22S068-SS-DWG-I-DQ-00078箱变电气主接线图-20250605173938-cbs4oeb.dwg)
> - 设备标注说明：[800kVA箱变全图](https://www.dq123.com/resources/detail/504319)
>
>   - ![image](assets/image-20250605174144-zysr495.png)
>   - ![image](assets/image-20250605174218-62x2bdj.png)
>   - ![image](assets/image-20250605174237-pb6h3om.png)
>   - ![image](assets/image-20250605174302-k9dfl82.png)
> - 其他案例：[80及100KVA](https://cad.3d66.com/reshtmla/cad/items/ZY/ZYDe01hZM5ZEGsE.html?searchActionId=7B65D956CB744E118BD3AE6CB89AF79F&kw=%E9%AB%98%E5%8E%8B%E7%AE%B1%E5%8F%98&sof=BCI392879711111343&st=2&click_res_source=1&lss=1&ab_flow=100&algorithm_version=1.0&group=1&source_alg=0&request_id=4E26FE8390EB4AE59A3FBE9A4B15EDC8&position=4&llt=2)
> - **参考资料**
>
>   - [箱式变压器原理和结构](https://www.bilibili.com/video/BV126WheJEo2)

## 配电箱浪涌保护

> - 案例图纸
>
>   - ![image](assets/image-20250606140545-mgxs2n3.png)
>   - 浪涌保护器：PRD-20KA/3P+N
> - **为什么要加浪涌保护器**
>
>   - 两个电极之间的电压因雷击或操作过电压而超过点火电压，间隙被击穿，则通过弧光放电释放过电压能量。冲击波过后，由分弧和灭弧室组成的灭弧系统将电弧熄灭，恢复到高阻状态以保护系统。
> - **为什么浪涌保护器前面要加断路器（或熔断器）？参数怎么选？**
>
>   - 如果浪涌保护器本身出现故障，将长时间连接（短路接地），导致电源系统短路。此时，前端熔断器（或断路器）需要及时切断接地电路，以确保电路的正常运行。
>   - 那么如何区分断路器或熔断器是雷击引起的短路(称为现象A）或者浪涌保护器本身损坏短路(称为现象B)
>   - 因为如果A被识别为B，断路器断开时，主电路会烧坏。雷电电流没有充分泄流，导致未让浪涌保护器起到保护电路的作用
>   - 如果B被识别为A，主电路会持续短路，导致电路烧坏。
> - **断路器参数怎么选？**
>
>   - **必选脱扣曲线**：**D型、K型或延迟型**（避免B/C型）
>
>     - ![image](assets/image-20250606145042-dx911m5.png)​
>   - **电流**
>
>     - - 最小值： \> SPD最大续流（如T2级选≥100A）；
>
>         - ![image](assets/image-20250606145340-3ge2tkn.png)
>       - 最大值： ≤上级断路器80%（保证选择性）；
>   - **接线**
>
>     - - 铜导线截面积 ≥ **10mm²**（减小感抗）
>       - 接线长度 ≤ **0.5m**（降低自感电压降）。
>   - **参考链接**
>
>     - [为什么浪涌保护器前面要加熔断器?](https://www.chinahugong.com/news/38.html)
>     - [防雷知识连载（三）| SPD的原理和选型](https://www.chenzhu-inst.com/chenzhu-mobile/knowledge/783.html)
>
>       - ![image](assets/image-20250606150512-qqkr9s7.png)
>       - **什么是工频续流？**
>
>         GDT（气体放电管），属于开关型元件，其开关状态取决于其内部空气是否被击穿。使用开关型元件的SPD称作开关型SPD。开关型，顾名思义，就是工作在“开”和“关”两种状态。
>
>         当电力线上的电压低于其开启电压时，其工作在“开”（高阻）的状态，当电力线电压高于其开启电压时（如电涌产生），其工作在“关”（导通）的状态，可以泄放很大的电流。开关型元件的导通状态通常是气体弧光放电的过程，因为维持弧光放电的电压只需要几十伏（通常低于电力线的额定工作电压），所以在电涌消失后，施加在SPD上的电力线电压使得弧光放电得以维持，这就是工频续流。工频续流会使得在电涌消失后，SPD无法返回到开路（高阻）状态，造成SPD发热甚至炸裂，引发火灾事故。所以开关型SPD一般只用于电源系统N-PE之间（或低压低流的信号系统中），如果要应用在电力线上，其必须具备续流遮断能力。

## 线缆命名规则

> - 规则
>
>   - 用途代号（常规导线省缺）：A-安装线；B-绝缘线；C-船用电缆；K-控制电缆；N-农用电缆；R-软线；U-矿用电缆；Y-移动电缆；JK-绝缘架空电缆；M-煤矿用；ZR-阻燃型；NH-耐火型；ZA-A 级阻燃；ZB-B 级阻燃；ZC-C 级阻燃；WD-低烟无卤型。
>   - 导体材料：L-铝；T-铜（省缺）。
>   - 绝缘种类：V-聚氯乙烯；X-橡胶；Y-聚乙烯；YJ-交联聚乙烯；Z-油浸纸。
>   - 内护（护套）层：V-聚氯乙烯护套；Y-聚乙烯护套；L-铝护套；Q-铅护套；H-橡胶护套；F-氯丁橡胶护套。
>   - 特征：D-不滴流；F-分相；CY-充油；P-贫油干绝缘；P-屏蔽；Z-直流；B-扁平型；R-柔软；C-重型；Q-轻型；G-高压；H-电焊机用；S-双绞型。
>   - 铠装层：0-无；2-双钢带；3-细钢丝；4-粗钢丝。
>   - 外被层：0-无；1-纤维外被；2-聚氯乙烯护套；3-聚乙烯护套。
>   - 防火特性：阻燃电缆在代号前加ZR；耐火电缆在代号前加NH；防火电缆在代号前加DH。
> - 示例
>
>   - YJV与YJV22等（YJV及以上俗称电缆，对比BV俗称电线，电压等级不同）
>
>     - YJV 3*4 与 YJV22-1kv 4*150
>
>       - ![image](assets/image-20250521172205-p13ulyh.png)​
>       - YJLV22就是铝芯交联聚乙烯绝缘，钢带铠装聚氯乙烯护套电力电缆。
>
>         - YJLV与YJV都不是带铠的。区分带不带铠，先看电缆型号里有无数字，再看数字是铠装层代号，还是外护层代号。
>     - YJV3*150+1*95
>
>       - ![image](assets/image-20250522093807-djg6vw8.png)
>   - BV：分为ZR-BV 和NH-BV
>
>     - 类别是绝缘线，用字母“B”表示
>     - 导体材料是铜，用字母“T”表示，铜芯导体省略表示
>     - 绝缘材料为聚氯乙烯，用字母“V”表示
>   - 常见型号
>
>     - VV：铜芯聚氯乙烯绝缘聚氯乙烯护套电力电缆。
>
>       YJV22：铜芯交联聚乙烯绝缘钢带铠装聚氯乙烯护套电力电缆。
>
>       KVV：聚氯乙烯绝缘聚氯乙烯护套控制电缆。
>
>       BV：铜芯聚氯乙烯绝缘电线。
>
>       RV：一般用途单芯软导体无护套电缆。

## 线缆载流量

> - 规范：[工业与民用供配电设计手册第四版.pdf](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf)
>
>   - [工业与民用供配电设计手册第四版.pdf - p867 - 9.3.3 交联聚乙烯绝缘电力电缆的载流量](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=867)（YJV）
>
>     - [工业与民用供配电设计手册第四版.pdf - p868 - 6-35kV在空气中敷设](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=868)
>     - [工业与民用供配电设计手册第四版.pdf - p869 - 6-35kV直埋地敷设](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=869)
>     - [工业与民用供配电设计手册第四版.pdf - p870 - 0.6/1kV YJV及乙丙橡股绝缘电缆明敷载流量](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=870)
>     - [工业与民用供配电设计手册第四版.pdf - p871 - 0.6/1kV YJV电缆桥架敷设](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=871)
>     - [工业与民用供配电设计手册第四版.pdf - p873 - 0.6/1kV YJV埋地敷设](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=873)
>   - [工业与民用供配电设计手册第四版.pdf - p873 - 9.3.4 聚氯乙烯绝缘电力电缆的载流量](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=873)（BV）
> - 参考资料
>
>   - [如何读懂设计院电气图纸——按载流量选截面](https://www.bilibili.com/video/BV1oj411j7Lf)

## 压降计算

> - 规范：[工业与民用供配电设计手册第四版.pdf](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf)
>
>   - [工业与民用供配电设计手册第四版.pdf - p893 - 9.4 线路电压降计算](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=893)
>
>     - [工业与民用供配电设计手册第四版.pdf - p905 - 9.4.6 电缆线路的电压降](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=905)
>
>       - [工业与民用供配电设计手册第四版.pdf - p907 - 1kV交联聚乙烯绝缘电力电缆（YJV）用于三相380V系统的电压降](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=907)
>       - [工业与民用供配电设计手册第四版.pdf - p909 - 1kV聚氯乙烯绝缘电力电缆（BV）用于三相380V系统的电降](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=909)
> - 压降：线材两端的电压差
> - 计算法
>
>   - 一、线阻-电流-压降法
>
>     - 1、线缆电阻
>
>       - 公式
>
>         - ![image](assets/image-20250605101932-di8lgkm.png)​
>       - 案例（1KM YJV3×4 线缆的电阻）
>
>         - ![image](assets/image-20250605102428-k7ov1lg.png)​
>     - 2、实际电流（220V/(R<sub>线缆</sub>+R<sub>设备</sub>，550W设备为例）
>
>       - ![image](assets/image-20250605102928-p6oj1ov.png)​
>     - 3、压降
>
>       - ![image](assets/image-20250606171810-g3037c6.png)​
>   - 二、查表法
>
>     - ![image](assets/image-20250606170737-5mfbe6x.png)
>     - 表
>
>       - [工业与民用供配电设计手册第四版.pdf - p907 - 1kV交联聚乙烯绝缘电力电缆（YJV）用于三相380V系统的电压降](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=907)
>       - [工业与民用供配电设计手册第四版.pdf - p909 - 1kV聚氯乙烯绝缘电力电缆（BV）用于三相380V系统的电降](assets/工业与民用供配电设计手册第四版-20250522085016-brjc4bl.pdf#page=909)
>     - 参考资料
>
>       - [如何读懂设计院电气图纸——按压降校验电缆截面](https://www.bilibili.com/video/BV1S94y1n7dv)
> - 如果长距离供电，压降超标，可以在末端加电源适配器来使设备正常运行吗？
>
>   - ![image](assets/image-20250606172637-i3bj1tk.png)​

‍
