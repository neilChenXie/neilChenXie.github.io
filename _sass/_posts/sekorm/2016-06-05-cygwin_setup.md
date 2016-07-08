---
layout: post
title: Cygwin
permalink: /:categories/cygwin
date: 2016-06-05 12:30:15 +0800
category: Sekorm
tags: [cygwin, bash]
---

Provide Linux Interface(POSIX) for Windows.

For who is used to using Linux.

**e.g.** all command, vim, and so on.

## Installation

### 1 Download **setup.exe** from official website

### 2 Install

Notice: when choose package, select **"Default"**. Install all will cost too much time.

## Software Management

1. Use **setup.exe** also.
2. Choose packages needed.

## Vim

### Vundle work fine

### 乱码问题 

[索引](https://www.evernote.com/shard/s250/nl/33206666/20bc2003-6fd2-4046-b03b-7a1f744f9e64?title=VIM%20%E6%96%87%E4%BB%B6%E7%BC%96%E7%A0%81%E8%AF%86%E5%88%AB%E4%B8%8E%E4%B9%B1%E7%A0%81%E5%A4%84%E7%90%86)

```bash
# bashrc
export LESSCHARSET=latin1
alias less='/bin/less -r'
alias ls='/bin/ls -F --color=tty --show-control-chars'
export LC_ALL=zh_CN.GBK
export LC_CTYPE=zh_CN.GBK
export LANG=zh_CN.GBK
export OUTPUT_CHARSET="GBK"

#vimrc
set encoding=utf-8
set fileencoding=utf-8

" support Windows Chinese "
set termencoding=gbk
set langmenu=zh_CN.UTF-8
language messages zh_CN.UTF-8
```
