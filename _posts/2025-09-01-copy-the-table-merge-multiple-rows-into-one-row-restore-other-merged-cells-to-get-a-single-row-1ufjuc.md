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
- 针对合并单元格，新增一列，使用公式：

  ```excel
  =IF(A2<>"", A2, "")
  ```
  ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/image-20250901152931-1vww0ck.png)
- 针对需要多行合并成一行

  ```excel
  =TEXTJOIN(CHAR(10),TRUE,OFFSET(C8,0,0,MATCH(TRUE,(N9:N$1000<>""),0),1))
  ```
  ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/image-20250901152823-iyxb245.png)
