---
title: 思源笔记：相同标签内容聚合，SQL按标签筛选内容块
date: '2026-01-06 15:36:43'
permalink: >-
  /post/siyuan-notes-aggregation-of-content-with-the-same-tags-sql-filtering-content-blocks-by-tags-zfa6mf.html
tags:
  - 思源笔记｜siyuan
  - digital_mind｜电子大脑
categories:
  - Software Development｜软件开发
layout: post
published: true
---



## 摘要

这个案例中，AI不知道思源笔记提供的一些变量及值的对应关系。go语言基本逻辑相关的代码，输出没有问题。

## 20260227更新

增加支持打上标签的文档（仅取`摘要`），并排除当前文档（防止自己引用自己）

{% raw %}

```go
.action{$docid:=.id}
.action{$searchTag:="#想聚合的标签"}

.action{/*获取母文件目录清单*/}
.action{$existTOCList:=(queryBlocks "SELECT * FROM blocks WHERE subtype='h3' AND root_id='?'" $docid)}



.action{/*获取所有含指定标签的文档，按创建时间正序*/}
.action{$tagFilesList:= (queryBlocks "SELECT * FROM blocks WHERE type='d' AND id !='?' AND tag LIKE '%?%' ORDER BY created" $docid $searchTag)}

.action{/*如果母文件已经添加过了，就不在重复添加*/}
.action{range $tagFileBlock:=$tagFilesList}
	.action{$existFlag:=0}
	.action{range $existTOC:=$existTOCList}
		.action{/*每个子文件的标题，逐个与母文件已有的目录清单做对比*/}
		.action{if eq $existTOC.Content $tagFileBlock.Content}
			.action{/*如果发现相同的，即设置标志位，并停止循环*/}
			.action{$existFlag = 1}
			.action{break}
		.action{end}
	.action{end}
	.action{/*如果标志位为0，说明该子文件标题不在母文件目录中*/}
	.action{if eq $existFlag 0}
	.action{/*输出该子文件标题及摘要*/}
### ((.action{$tagFileBlock.ID} ".action{$tagFileBlock.Content}"))
		.action{$hl:= (queryBlocks "SELECT * FROM blocks WHERE subtype='h2' and parent_id='?' and content LIKE '%摘要%'" $tagFileBlock.ID)}
		.action{range $h:=$hl} 
{{SELECT * FROM blocks WHERE parent_id='.action{$h.ID}'}}
		.action{end}
	.action{end}
.action{end}

.action{/*获取所有含指定标签的H2内容块，按创建时间倒序*/}
.action{$tagBlocksList:= (queryBlocks "SELECT * FROM blocks WHERE subtype='h2' AND content LIKE '%?%' ORDER BY created" $searchTag)}

.action{/*如果母文件已经添加过了，就不在重复添加*/}
.action{range $tagBlock:=$tagBlocksList}
	.action{$existFlag:=0}
	.action{range $existTOC:=$existTOCList}
		.action{/*每个子文件的标题，逐个与母文件已有的目录清单做对比*/}
		.action{if eq $existTOC.Content $tagBlock.Content}
			.action{/*如果发现相同的，即设置标志位，并停止循环*/}
			.action{$existFlag = 1}
			.action{break}
		.action{end}
	.action{end}
	.action{/*如果标志位为0，说明该子文件标题不在母文件目录中*/}
	.action{if eq $existFlag 0}
	.action{/*输出该子文件标题及摘要*/}
### ((.action{$tagBlock.ID} ".action{$tagBlock.Content}"))
{{SELECT * FROM blocks WHERE parent_id='.action{$tagBlock.ID}'}}
	.action{end}
.action{end}


```

{% endraw %}

## 20260215结果

{% raw %}

```go
.action{$docid:=.id}
.action{/*获取所有含指定标签的H3内容块，按创建时间倒序*/}
.action{$tagBlocksList:= (queryBlocks "SELECT * FROM blocks WHERE subtype='h2' AND content LIKE '%?%' ORDER BY created desc" "#git")}

.action{/*获取母文件目录清单*/}
.action{$existTOCList:=(queryBlocks "SELECT * FROM blocks WHERE subtype='h3' AND root_id='?'" $docid)}

.action{/*如果母文件已经添加过了，就不在重复添加*/}
.action{range $tagBlock:=$tagBlocksList}
	.action{$existFlag:=0}
	.action{range $existTOC:=$existTOCList}
		.action{/*每个子文件的标题，逐个与母文件已有的目录清单做对比*/}
		.action{if eq $existTOC.Content $tagBlock.Content}
			.action{/*如果发现相同的，即设置标志位，并停止循环*/}
			.action{$existFlag = 1}
			.action{break}
		.action{end}
	.action{end}
	.action{/*如果标志位为0，说明该子文件标题不在母文件目录中*/}
	.action{if eq $existFlag 0}
	.action{/*输出该子文件标题及摘要*/}
### ((.action{$tagBlock.ID} ".action{$tagBlock.Content}"))
{{SELECT * FROM blocks WHERE parent_id='.action{$tagBlock.ID}'}}
	.action{end}
.action{end}
```

{% endraw %}

## 二、Claude Code输出思源笔记模板经验 #vibe_coding#

### 提示词

```bash
参考《1.1 父文档目录（倒序）.md》文件，写一个思源笔记的模板文件，按某个标签读取所有含该标签的H3内容块，并按创建时间倒序，创建在当前文件里，其中标题和内容参考《1.1父文档目录（倒序）.md》
```

### AI输出结果

{% raw %}

```go
.action{$docid:=.id}
.action{/*获取所有含指定标签的H3内容块，按创建时间倒序*/}
.action{$h3Blocks:= (queryBlocks "SELECT * FROM blocks WHERE type='d' AND subtype='h3' AND box LIKE '%?%' ORDER BY created desc" "#指定标签")}

.action{range $h3Block:=$h3Blocks}
### ((.action{$h3Block.ID} ".action{$h3Block.Content}"))
{{SELECT * FROM blocks WHERE parent_id='.action{$h3Block.ID}'}}
.action{end}
```

{% endraw %}

### Debug

对比《父文档生成子文件清单及摘要》发现的问题

- ​`type='d'`是指“文档”类型，删掉即可
- ​`box`​应该替换成`content`

修改是之后可以正常显示。因为提示词没有相关“去重”的要求，所以没有copy参考内容的“去重”代码。

### 总结

AI不知道思源笔记提供的一些变量及值的对应关系。

go语言基本逻辑相关的代码，输出没有问题。
