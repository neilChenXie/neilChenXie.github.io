---
title: 复制的表格，将多行合并到一行，将其他的合并单元格还原拿到单行
date: '2025-09-01 15:09:04'
permalink: >-
  /post/copy-the-table-merge-multiple-rows-into-one-row-restore-other-merged-cells-to-get-a-single-row-1ufjuc.html
tags:
  - excel｜表格
categories:
  - Tool｜工具效率
layout: post
published: true
---





# 摘要

- 示例文件：[示例文件.xlsx](assets/示例文件-20250901152946-yra94bv.xlsx)
- **对于“已合并变单行”列：** 新增一列，使用公式：

  ```excel
  =IF(A2<>"", A2, "")
  ```

  ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/image-20250901152931-1vww0ck.png)
- **对于“要多行并一行”的列：** 使用以下公式

  ```excel
  =TEXTJOIN(CHAR(10),TRUE,OFFSET(C8,0,0,MATCH(TRUE,(N9:N$1000<>""),0),1))
  ```

  ​`offset`​中，`C8`​是原表格第一行，`Match`​中，注意`N9`​是从`参考列N`​的 **【下一行】** 开始

  ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/image-20250901152823-iyxb245.png)

  - **Match函数：**​`Match(匹配值，区域寻找值，匹配模式）`

    ```excel
    MATCH(TRUE,(N9:N$1000<>""),0)
    ```

    - ​`匹配模式`:

      - 0 `区域寻找值`​=`匹配值`
      - 1：`区域寻找值`​≥`匹配值`
      - -1：`区域寻找值`​≤`匹配值`
  - **OFFSET函数：**
- **检查最后一行：** 最后一行出现`#N/A`​,是因为Match函数输出为`#N/A`。

  ![image](http://127.0.0.1:53231/assets/image-20251109115206-8xolyu8.png)
- 对第N列，进行 **“筛选-复制-粘贴值”** （不能“筛选-定位-删除”，因为此时删除，导致**多行并一行**的<span data-type="text" style="color: var(--b3-font-color8);">数据源</span>变化了 **）**

  - **对于“已合并变单行”列，** 进行筛选

    ![image](http://127.0.0.1:53231/assets/image-20251109123129-iij6z1a.png)
  - **选择-复制-粘贴值**，即可。
  - **错误操作：** “筛选-定位-删除”

    - **对于“已合并变单行”列，** 进行筛选

      ![image](http://127.0.0.1:53231/assets/image-20251109120833-4p7yoqp.png)
    - 全选筛选列，在`查找`​选择`定位`​，选择`“可见单元格”`

      ![image](http://127.0.0.1:53231/assets/image-20251109121211-337zrmh.png)

      ![image](http://127.0.0.1:53231/assets/image-20251109121257-u71d6a0.png)
    - 选择`“删除”-“删除整行”`

‍
