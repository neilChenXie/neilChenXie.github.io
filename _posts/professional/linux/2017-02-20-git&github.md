---
title: Git & GitHub
date: 2016-05-30 14:00:15 +0800
category: Linux
tags: [linux, linux-tool]
---

### 1 Config

```sh
# name,email 涉及contribution统计

git config --global user.name "Chen Xie"
git config --global user.email "chenxie2016@outlook.com"

# simple for current branch, matching for all branches

git config --global push.default simple

# sensitive to up/lower case

git config core.ignorecase false

# check all config
git config --list
```

### 2 SSH Key

```sh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

#under ~/.ssh/
#id_rsa.pub is public key for GitHub

# different location to generate key Files
ssh-keygen -t rsa -f ~/Documents/sshkey/{name}
```

### 3 Recovery

#### 3.1 for entire folder

```bash
git reset --hard # discard all changes
git clean -f -d #remove untracked
git clean -f -d -x # above plus ignored file
```

#### 3.2 for file

```sh
# last commit
git checkout filename

# one commit
git log
# choose one commit to recover
git checkout --HEAD filename
```

#### 3.3 for commit point

```sh
#TODO
git reset
```

### 4 Change Remote Repo

```bash
# set new remote repo url

git remote set-url origin {url}

# 查看现有Remote Repo

git remote -v
```


### 5 Tag

> [资料](https://git-scm.com/book/zh/v1/Git-%E5%9F%BA%E7%A1%80-%E6%89%93%E6%A0%87%E7%AD%BE)


### 6 Show Changes

#### 6.1 all unstaged(committed) Changes

```bash
git diff --cached
```

### 7 Problem

#### contribution 不显示（记录）

[match principle](https://help.github.com/articles/why-are-my-contributions-not-showing-up-on-my-profile/)

### 8 Files

#### 8.1 .gitignore

> Add .gitignore file later, to apply the file:

```
git rm -r --cached .
git add .
```

```
### General
*.[oa] *~      # Gedit
.*.sw[po]     # Vim
.DS_Store  # Mac_OS

### Java

#### Mobile Tools for Java (J2ME)

.mtj.tmp/

#### compile

*.class
target

#### Package
*.war
*.ear
*.jar

#### Eclipse
.project
.classpath
.settings
.metadata

#### virtual machine crash logs, see http://www.java.com/en/download/help/error_hotspot.xml
hs_err_pid*
```
