---
layout: post
title: OS X Homebrew源及包管理
permalink: /:categories/homebrew/
date: 2016-06-06 13:16:15 +0800
category: OSX
tags: [osx, homebrew]
---

### 改变源

```bash
cd /usr/local
git remote set-url origin git://mirrors.ustc.edu.cn/brew.git
```

### 改变bottle源

```bash
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bashrc
```

### 文件查看位置

```bash
brew list $pkgName
brew info $pkgName
```
