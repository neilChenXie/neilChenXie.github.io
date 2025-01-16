---
title: 'Debug Jekyll & Github_Page '
date: '2025-01-16 16:20:55'
permalink: /post/debug-jekyll-5qa0l.html
tags:
  - jekyll
  - github_pages
categories:
  - Software Development
layout: post
published: true
---

# Debug Jekyll & Github_Page

# 摘要

# 详细记录

## 20251016

> * 问题：新发的文章总是没有在博客显示
> * 找到原因过程：
>
>   * 发现Github Action
>
>     * ​![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250116162538-d3h2l3k.png)​
>     * ​![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250116162600-ibjjvmv.png)​
>     * ​![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250116162719-t3owkc3.png)​
>   * 研究Github Action
>
>     * 下载编译完的文件，发现没有最新的文章
>
>       * ​![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250116162824-9g3zrbg.png)​
>     * 研究Build里的信息
>
>       * ​![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250116162900-bdvup6u.png)​
>       * ​![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250116162919-ot1c19i.png)​
>     * 发现读取了源文件，但是编译Skip了
>
>       * ​![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250116163007-qri8kva.png)​
>       * ​![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250116163058-cuv740e.png)​
>     * 猜到可能是时区的问题，
> * 原因：Github默认时区是美国西部，比中国差不多晚一天，所以发布的文章都成了“Has a Future Date”
> * 解决办法：在_config.yml文件中，增加Timezone的设置
>
>   * ​![image](https://cdn.jsdelivr.net/gh/neilChenXie/ChenVideo/pic/image-20250116164152-pjzv8lu.png)​
> * 参考链接：[jekyll Configuration Options](https://jekyllrb.com/docs/configuration/options/#global-configuration)
