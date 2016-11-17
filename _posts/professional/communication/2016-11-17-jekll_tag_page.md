---
title: Jekyll博客标签页
date: 2016-11-17 9:30:15 +0800
category: communication
tags: [jekyll, liquid]
---

> 博客的标签页基本是一个不可或缺的功能，它能更灵活地将博客按多类别体系组织起来。
> jekyll会存储文章的标签信息，但是不会生成以标签组织的静态页面，所以需要利用**Collection**机制来生成。

### Tag Cloud 页面

> 所有标签展示页

{% raw %}
```html
---
layout: page
permalink: /tags/
---

<h1>Tag Cloud</h1>
<div class="tag-meta">
	{% assign tags = site.tags | sort %}
	{% for tag in tags %}
	<li>
	<a class="tag-link" href="{{ site.baseurl }}/tag/{{ tag | first | slugify }}/"
		style="font-size: {{ tag | last | size  |  times: 4 | plus: 90  }}%">
		<!--<a href="{{ site.baseurl }}/tag/{{ tag | first | slugify }}/">-->
		<span class="term">{{ tag[0] | replace:'-', ' ' }}</span><span class="count">{{ tag | last | size }}</span>
	</a>
	</li>
	{% endfor %}
</div>
```
{% endraw %}


### Tag详情页

> jekyll博客是静态页面，要访问`/tag/hello/`,就需要生成`_site/tag/hello/index.html`文件，但是jekll默认不会生成以标签组织的静态页面，所以需要利用Collection机制来生成。


#### _config.yml

{% raw %}
```yml
#声明collection
collections:
  tags_page:                    #自定义，根目录下文件夹_tags_page
      output: true              #生成静态页面

#tag_page统一yml头信息
defaults:
    - scope:
        path: ""                #所有路径下
        type: tags_page         #指明类别
      values:
        layout: page_tag        #声明layout
        permalink: /tag/:title/  #链接
```
{% endraw %}

#### 文件

1  根目录下生成`_tags_page/`文件夹，注意`_`。该目录下的文件对应一个详情页。

{% raw %}
> e.g. `jekyll` tag:

> `jekyll.html`
>```html
---
---
```
{% endraw %}

2  `_layouts/page_tag.html` 用于详情页的layout

{% raw %}
```html
---
layout: page-horizontal
---

{% if site.tags[page.slug] %}
	{% for post in site.tags[page.slug] %}
	<a href="{{ site.baseurl }}{{ post.url }}" title="{{ post.title }}">
		<h3 class="article-list-h3">{{ post.title }}</h3>
	</a>
		<span class="article-list-date">
			{{ post.date | date: "%B %-d, %Y" }}
		</span>
	<p>{{ post.content | truncatewords:50 | strip_html }}</p>
	<div class="article-list-footer">
		<ul class="article-list-tags">
			{% for tag in post.tags %}
			<li>
			<a href="{{ site.baseurl }}/tag/{{ tag }}" class="tag-link" title="See all posts by this tag">
				<span class="term_only"> {{ tag }}</span>
			</a>
			</li>
			{% endfor %}
		</ul>
	{% endfor %}
{% else %}
<p class="article-empty">
There are no posts in {{ page.slug }}.
</p>
{% endif %}
```
{% endraw %}

#### Reference

* [permalink变量](https://jekyllrb.com/docs/permalinks/)
* [_config.yml配置](https://jekyllrb.com/docs/configuration/)
* [Collection](https://jekyllrb.com/docs/collections/)
