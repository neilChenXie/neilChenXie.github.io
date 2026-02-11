---
title: Slugify问题：「digital_mind｜电子大脑」标签无法访问
date: '2026-02-11 09:30:01'
permalink: >-
  /post/slugify-problem-digitalmind-electronic-brain-tag-cannot-be-accessed-zrrvpm.html
tags:
  - jekyll
categories:
  - Software Development｜软件开发
layout: post
published: true
---



## 摘要

### Jekyll Debug经验：Collections功能的逻辑学习

![](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/excalidraw-image-20260210172030-v0xsipn.svg)

### AI使用经验

不要一来就使用agent，让AI开始改代码。先使用ask，定位问题在哪。

因为，Bug不一定需要很大的代码量，最重要的找到问题所在。

## 问题

点击首页、博客正文页的标签，显示无法访问

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260209180618-0mqlpp6.png)

## 问题原因

博客正文页的标签链接，在_layouts/post.html中：

标签页是基于`_tags_page/[tag_name｜标签名].md`​文件，渲染到`_site/tag/[tag_name-标签名]`​，注意文件名会被`slugify`处理。

**然后发现：** 在页面中，使用`{{ tag | slugify }}`​，`digital_mind｜电子大脑`​会变成`digital-mind-电子大脑`​，但是`_tag_page/digital_mind｜电子大脑.md`​文件编译到`_site/tag/`​下变成了`digital_mind-电子大脑`​，导致`http://127.0.0.1:4000/tag/digital-mind-电子大脑`​无法访问到`_site/tag/digital_mind-电子大脑`

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260209180836-dr92yqt.png)

因此，在页面中`{{ tag | slugify }}`​会将所有的特殊字符都变成`-`​，即`digital_mind｜电子大脑`​会变成`digital-mind-电子大脑`​，所以，核心是搞清楚`_tag_page/digital_mind｜电子大脑.md`​到`_site/tag/digital_mind-电子大脑`的逻辑是什么？

## 尝试

### 尝试一

修改`tag_generator.rb`​，将`_tag_page/`​下的文件都变为`digital-mind-电子大脑.md`。

**结果：**

可以访问了，但是，关联不出标签下的内容：

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260210101322-r5y172k.png)

**对应代码：**

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260210101348-jm6x6pt.png)

说明文章是需要**原标签名**关联出来的。

### 尝试二

在`_tag_page/`分别定义title和slug参数，用于检索内容，文件名保持尝试一的情况：

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260210101702-krtyv1s.png)

**结果：**

在`_site/tag/`​下还是生成`digital_mind-电子大脑`​文件，说明不是受`_tag_page/`​的文件名影响的，而是受`title`​or`slug`参数影响。

### 尝试三

**通过问AI：** jekyll 是如何将_tags_page/下的tag.md文件编译到_site/tag文件下的？

**得到回答:**

简短流程（针对你当前工程的配置）

- 在 _config.yml 里你声明了一个集合：

  - collections:  
    tags_page:  
    output: true  
    因此 _tags_page/ 下的每个文件都会被当作可输出的页面渲染并写入 _site。
- 你通过 defaults 为 tags_page 指定了永久链接模板：

  - permalink: /tag/:title/  
    这个模板会被用于集合中每个文档（除非单个文档的 front matter 覆盖）。
- 构建时 Jekyll 用 permalink 模板替换占位符并生成实际路径：

  - :title → 使用文档 front matter 中的 title（若无则用文件名或自动生成）
  - 最终写入的文件路径类似： _site/tag/<替换后的 title>/index.html （因为末尾有 /，Jekyll 生成目录 + index.html）
- 如果改用 :slug：

  - Jekyll 会使用 page.slug（或内部对 title/file 名称做 slugify 的结果），生成的目录名更“URL-safe”。

总结：_tags_page 下的文件之所以出现在 _site/tag/ 下，是因为集合被设置为 output: true 且为该集合指定了 /tag/:title/ 的 permalink，构建时 Jekyll 按模板生成对应目录并写入 index.html。

### 最终解决：将`:title`​改为`:slug`，解决

但是原理还是不够清楚，见后面深入理解。

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260209181335-lh3twdq.png)

## 深入理解

### 对Jekyll的理解：Collections[^1]

> **问：** 通过`_config.yml`配置，为什么jekyll知道去_tag_page目录找标签聚合页的每个标签页面的md文件？

> **答：** 通过`_config.yml`​中`collections:`​配置的`集合`​的名字，在前面加上`_`，找对应的目录。

> **问：** 配置中`permalink: /tag/:slug/`​的`:slug`是怎么取值的？

> **答：** 按以下默认顺序：Front Matter中的slug -> Front Matter中的title（slug处理后） -> 文件名（slug处理后）

> ```bash
> 配置: collections.tags_page.permalink = "/tag/:slug/"
> ↓
> Jekyll 扫描 _tags_page/ 文件夹
> ↓
> 对每个文件：
>   1. 读取 front matter
>   2. 确定 slug 值（优先级：slug > title > 文件名）
>   3. 替换 permalink 中的 :slug
>   4. 生成到 _site/tag/[slug]/index.html
> ```

> **问：** 那如果front matter中的slug值，也有特殊字符，比如`digital_mind｜电子大脑`，会被slugify处理吗？

> **答：** 通过我的测试，会被slugify处理，且与{{ tag | slugify }}处理结果一致。`digital_mind｜电子大脑`​会变成`digital-mind-电子大脑`​。<span data-type="text" style="color: var(--b3-font-color8);">这与网上的资料记录不一致（所以问AI 回答也是错误的）</span>

> **发现一个问题：** 如上图，title和slug都是`digital_mind｜电子大脑`​，但是`_config.yml`​中，配置`/tag/:title/`​和`/tag/:slug/`​，在_site/tag/下生成的目录名称不同，`:title`​是`digital_mind-电子大脑`​，`:slug`​是`digital-mind-电子大脑`。

> ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260210110829-hdgzj8v.png)

> ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260210112626-n29fl6w.png)

### jekyll博客中page_tag.html中如何关联出标签下的文章[^2]

> ​`site.tags` - Jekyll的全局变量，包含所有文章的标签及其对应的文章列表。它是一个键值对对象，格式为：

> ```
> {
>   "tag1": [post1, post2, ...],
>   "tag2": [post3, post4, ...],
>   ...
> }
> ```

> ​`{% if site.tags[page.slug] %}`就是访问某个标签下的post清单。

> 所以，如果post（博文）中的标签是`digital_mind｜电子大脑`​，那么这里的取值需要是`digital_mind｜电子大脑`​，而不能是slugify之后的`digital-mind-电子大脑`​或`digital_mind-电子大脑`。

> 所以，`_tags_page`​下的md文件可以是以下写法，然后这里改成`site.tags[page.title]`

> ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260210113703-nbhawd7.png)

## AI改BUG使用经验 #vibe_coding#

### 摘要

不要一来就使用agent，让AI开始改代码。先使用ask，定位问题在哪。

因为，Bug不一定需要很大的代码量，最重要的找到问题所在。

### 在`tag_generator.rb`：

**提示词：** 在这里，需要将标签的名称slugify；

结果：可以运行，但是｜和中文被去掉了

**提示词：** 将｜装换为-，保留中文

结果：中文保留了，但是｜不见了

**提示词：** 现在处理完｜不见了，需要将“｜”替换成“-”

结果：满足预期

**评价：在文件中，写函数的能力还是可以的**

### 这个项目，生成的标签列表页“digital-mind-电子大脑”，显示“There are no posts in digital-mind-电子大脑.”，是什么问题？

能基本找到问题。但是agent直接改代码，感觉因为改了`tag_generator.rb`​后`_tags_page`​的文件需要先删除再运行`jekyll serve`​来创建，但AI没发现，导致`_tags_page`​文件没更新，Debug陷入了**牛角尖**（一直在看为什么写入文件不对） **。** 

**评价：能够相对准确地找到问题在哪。**

## Git在一个分支上做了修改，但是还没有提交，能否在另外一个分支上提交 #git#

### 场景

我的博客项目，在SE_Road分支git pull了最新发布的内容，发现了博客tag系统的bug，然后直接在这个分支上做了很多调整，现在Bug调完了，我是否可以换一个分支专门提交博客框架上的修改。

### 解决方案

不需要。可以通过选择特定的文件，来创建一个commit只提交框架相关的提交；然后第二个commit再提交博客和标签页的修改。

```bash
# add 特定文件
git add _layouts/page_tag.html _plugins/tag_generator.rb _config.yml 

# 查看哪些文件staged
git status

# unstaged不属于框架文件的文件
git restore --staged _posts/

# 提交框架的修改 并与github上的bug编号对应
git commit -m "Slugify问题：「digital_mind｜电子大脑」标签无法访问 fixes #51"
```

然后其他博客发布分支，用`git rebase main`​来更新框架文件（其实也同步了其他分支发布的博客），不过每个分支的文章应该是不冲突的，所以可以就用`rebase`

‍

[^1]: # 对Jekyll的理解：Collections

    ## 摘要

    **问：** 通过`_config.yml`配置，为什么jekyll知道去_tag_page目录找标签聚合页的每个标签页面的md文件？

    **答：** 通过`_config.yml`​中`collections:`​配置的`集合`​的名字，在前面加上`_`，找对应的目录。

    **问：** 配置中`permalink: /tag/:slug/`​的`:slug`是怎么取值的？

    **答：** 按以下默认顺序：Front Matter中的slug -> Front Matter中的title（slug处理后） -> 文件名（slug处理后）

    ```bash
    配置: collections.tags_page.permalink = "/tag/:slug/"
    ↓
    Jekyll 扫描 _tags_page/ 文件夹
    ↓
    对每个文件：
      1. 读取 front matter
      2. 确定 slug 值（优先级：slug > title > 文件名）
      3. 替换 permalink 中的 :slug
      4. 生成到 _site/tag/[slug]/index.html
    ```
    **问：** 那如果front matter中的slug值，也有特殊字符，比如`digital_mind｜电子大脑`，会被slugify处理吗？

    **答：** 通过我的测试，会被slugify处理，且与{{ tag | slugify }}处理结果一致。`digital_mind｜电子大脑`​会变成`digital-mind-电子大脑`​。<span data-type="text" style="color: var(--b3-font-color8);">这与网上的资料记录不一致（所以问AI 回答也是错误的）</span>

    ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260210110829-hdgzj8v.png)

    **发现一个问题：** 如上图，title和slug都是`digital_mind｜电子大脑`​，但是`_config.yml`​中，配置`/tag/:title/`​和`/tag/:slug/`​，在_site/tag/下生成的目录名称不同，`:title`​是`digital_mind-电子大脑`​，`:slug`​是`digital-mind-电子大脑`。

    ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260210112626-n29fl6w.png)

    ## 1. 为什么 Jekyll 知道去 `_tags_page/`目录？

    ### 关键机制：**集合（Collections）**

    在 `_config.yml`中：

    ```
    collections:
      tags_page:  # 这里定义了集合名称
        output: true
        permalink: /tag/:slug/
    ```
    ​**工作原理**：

    1. ​**命名约定**​：Jekyll 会自动扫描项目根目录下以 `_`开头且与集合名称相同的文件夹
    2. ​**映射关系**：

       ```
       配置中的集合名称: tags_page
       ↓
       对应的文件夹: _tags_page/
       ```
    3. ​**自动识别**：不需要额外指定路径，这是 Jekyll 的内置约定

    ### 对比其他集合

    ```
    collections:
      docs:       # → 对应 _docs/ 文件夹
        output: true
      
      tutorials:  # → 对应 _tutorials/ 文件夹
        output: true
      
      tags_page:  # → 对应 _tags_page/ 文件夹
        output: true
    ```
    ## 2. `:slug`是如何取值的？

    ​`:slug`的值来源于多个可能的来源，按优先级排序：

    ### 优先级顺序：

    ```
    1. Front Matter 中的 slug
    2. Front Matter 中的 title（处理后）
    3. 文件名（处理后）
    ```
    ### 详细取值逻辑：

    #### 情况 1：Front Matter 中有明确的 `slug`

    ```
    # _tags_page/jekyll.md
    ---
    slug: "jekyll-tutorials"  # ← 明确指定
    title: "Jekyll教程"
    ---
    ```
    结果：`:slug`​\= `"jekyll-tutorials"`​→ `/tag/jekyll-tutorials/`

    #### 情况 2：Front Matter 中没有 slug，但有 title

    ```
    # _tags_page/ruby.md
    ---
    title: "Ruby Programming"  # ← 没有 slug，使用 title
    ---
    ```
    处理过程：

    1. 获取 `title`​: `"Ruby Programming"`
    2. 转换为小写：`"ruby programming"`
    3. 替换特殊字符为连字符：`"ruby-programming"`
    4. 删除特殊符号

       结果：`:slug`​\= `"ruby-programming"`​→ `/tag/ruby-programming/`

    #### 情况 3：既没有 slug 也没有 title

    ```
    # _tags_page/web.md
    ---
    # 空的 front matter
    ---
    ```
    处理过程：

    1. 获取文件名：`web.md`
    2. 去掉扩展名：`web`
    3. 特殊处理（如已有连字符等）

       结果：`:slug`​\= `"web"`​→ `/tag/web/`

    ### 3. 验证和调试

    您可以通过创建测试文件验证：

    ```
    # _tags_page/test-slug.md
    ---
    title: "My Awesome Post!"
    slug: "custom-slug"
    ---
    ```
    ```
    # _tags_page/test-title.md
    ---
    title: "Another Great Post"
    # 没有 slug
    ---
    ```
    ```
    # _tags_page/test-filename.md
    ---
    # 空的 front matter
    ---
    ```
    生成后检查：

    ```
    _site/tag/custom-slug/index.html      # 从 slug
    _site/tag/another-great-post/index.html  # 从 title
    _site/tag/test-filename/index.html    # 从文件名
    ```
    ### 4. 源码解析（简化版）

    Jekyll 内部处理 permalink 的伪代码：

    ```
    def generate_permalink(page)
      # 优先级 1: front matter 中的 slug
      if page.data['slug']
        return page.data['slug']
      
      # 优先级 2: front matter 中的 title
      elsif page.data['title']
        return slugify(page.data['title'])
      
      # 优先级 3: 文件名
      else
        return File.basename(page.path, '.*')
      end
    end

    def slugify(text)
      text.downcase
          .gsub(/[^\w\s-]/, '')  # 删除特殊字符
          .gsub(/\s+/, '-')      # 空格变连字符
          .gsub(/--+/, '-')      # 多个连字符变一个
          .strip
    end
    ```
    ### 5. 特殊字符处理示例

    |Front Matter 值|生成的 slug|最终 URL|
    | -----------------| -------------| ----------|
    |​`title: "C++ Tutorial"`|​`c-tutorial`|​`/tag/c-tutorial/`|
    |​`slug: "c-plus-plus"`|​`c-plus-plus`|​`/tag/c-plus-plus/`|
    |​`title: "Ruby on Rails"`|​`ruby-on-rails`|​`/tag/ruby-on-rails/`|
    |文件名: `node-js.md`|​`node-js`|​`/tag/node-js/`|

    ### 6. 高级配置：自定义 slug 逻辑

    可以通过插件自定义 slug 生成：

    ```
    # _plugins/slug_filter.rb
    module Jekyll
      module SlugFilter
        def custom_slugify(input)
          input.to_s.downcase.strip
               .gsub(' ', '-')
               .gsub(/[^\w-]/, '')
        end
      end
    end

    Liquid::Template.register_filter(Jekyll::SlugFilter)
    ```
    然后在模板中使用：

    ```
    {% assign tag_slug = page.title | custom_slugify %}
    ```
    ### 7. 实际工作流程总结

    ```
    配置: collections.tags_page.permalink = "/tag/:slug/"
    ↓
    Jekyll 扫描 _tags_page/ 文件夹
    ↓
    对每个文件：
      1. 读取 front matter
      2. 确定 slug 值（优先级：slug > title > 文件名）
      3. 替换 permalink 中的 :slug
      4. 生成到 _site/tag/[slug]/index.html
    ```
    ### 8. 调试技巧

    查看生成的 slug：

    ```
    <!-- 在模板中添加 -->
    <p>Debug: slug = {{ page.slug }}</p>
    <p>Debug: permalink = {{ page.permalink }}</p>
    <p>Debug: url = {{ page.url }}</p>
    ```
    或者在配置中启用详细日志：

    ```
    # _config.yml
    debug: true
    ```
    ## 总结

    1. ​**目录识别**​：Jekyll 通过 `collections`​配置中的名称自动匹配 `_`开头的同名文件夹
    2. ​**slug 取值**​：按 `front matter 的 slug → front matter 的 title → 文件名`的优先级获取，并进行标准化处理
    3. ​**URL 生成**​：用确定的 slug 值替换 permalink 模板中的 `:slug`占位符

    这种设计既提供了灵活性（可以手动指定 slug），又保证了默认情况下的可用性。

    ‍


[^2]: # jekyll博客中page_tag.html中如何关联出标签下的文章

    ## 摘要

    ​`site.tags` - Jekyll的全局变量，包含所有文章的标签及其对应的文章列表。它是一个键值对对象，格式为：

    ```
    {
      "tag1": [post1, post2, ...],
      "tag2": [post3, post4, ...],
      ...
    }
    ```
    ​`{% if site.tags[page.slug] %}`就是访问某个标签下的post清单。

    所以，如果post（博文）中的标签是`digital_mind｜电子大脑`​，那么这里的取值需要是`digital_mind｜电子大脑`​，而不能是slugify之后的`digital-mind-电子大脑`​或`digital_mind-电子大脑`。

    所以，`_tags_page`​下的md文件可以是以下写法，然后这里改成`site.tags[page.title]`

    ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260210113703-nbhawd7.png)

    ## ​`site.tags[page.slug]` 的含义

    这是一个Jekyll访问关联数组的语法，具体含义如下：

    - ​**​`site.tags`​** - Jekyll的全局变量，包含所有文章的标签及其对应的文章列表。它是一个键值对对象，格式为：

      ```
      {
        "tag1": [post1, post2, ...],
        "tag2": [post3, post4, ...],
        ...
      }
      ```
    - ​**​`page.slug`​**​ - 当前页面的`slug`值（在你的front matter中定义）
    - ​**​`site.tags[page.slug]`​** ​ - 使用`page.slug`​作为键，从`site.tags`中获取对应的所有文章数组

    ## 实际例子

    如果你的页面`slug`​是`road-map`​，那么`site.tags[page.slug]`​就会获取所有被标记为`road-map`的文章列表。

    例如，如果有三篇文章都带有`tags: [road-map]`​标签，那么`site.tags["road-map"]`​会返回这三篇文章的数组，然后`{% for post in site.tags[page.slug] %}`就会遍历这三篇文章。

    ## 为什么使用`slugify`？

    注意下面这行代码：

    ```html
    <a href="{{ site.baseurl }}/tag/{{ tag | slugify }}" ...>
    ```
    这里使用`| slugify`​过滤器将标签转换为URL安全的格式（例如`road map`​变成`road-map`​），但是访问`site.tags`​时使用的是原始的`page.slug`值。这两者的格式需要保持一致才能正确匹配！
