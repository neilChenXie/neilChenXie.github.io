---
title: Github & git
date: '2025-01-16 10:03:25'
permalink: /post/girub-bxpww.html
tags:
  - git
  - github
categories:
  - Work｜工作
  - Software Development｜软件开发
layout: post
published: true
---





# 摘要

```bash
#Config
# name,email 涉及contribution统计
git config --global user.name "Chen Xie"
git config --global user.email "chenxie2016@163.com"

# 查看设置
git config --list

# check the origin URL AND modify the origin URL
git remote -v
git remote set-url origin <NEW_GIT_URL_HERE>
# simple for current branch, matching for all branches

git config --global push.default simple

# sensitive to up/lower case

git config core.ignorecase false

# check all config
git config --list

#SSH
#Generate your key with your email.
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
#all key file under ~/.ssh/
#id_rsa is private key, don't give it to anyone.  
#id_rsa.pub is public key for GitHub

# different location to generate key Files
ssh-keygen -t rsa -f ~/Documents/sshkey/{name}

#ADD、Commit、Push
# git add all files 
git add .

# commit
git commit -m ""

git push origin main
```

# 详细记录

## Config

```bash
# name,email 涉及contribution统计

git config --global user.name "Chen Xie"
git config --global user.email "chenxie2016@163.com"

# check the origin URL AND modify the origin URL
git remote -v
git remote set-url origin <NEW_GIT_URL_HERE>
# simple for current branch, matching for all branches

git config --global push.default simple

# sensitive to up/lower case

git config core.ignorecase false

# check all config
git config --list
```

## SSH key

```bash
#Generate your key with your email.
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
#all key file under ~/.ssh/
#id_rsa is private key, don't give it to anyone.  
#id_rsa.pub is public key for GitHub

# different location to generate key Files
ssh-keygen -t rsa -f ~/Documents/sshkey/{name}
```

## .gitignore

### rm files which are tracked before it is added to .gitignore

```bash
git rm -r --cached .
git add .
```

- reference: [How do I make Git forget about a file that was tracked, but is now in .gitignore?](https://stackoverflow.com/questions/1274057/how-do-i-make-git-forget-about-a-file-that-was-tracked-but-is-now-in-gitignore)

### .gitignore file

```bash
### General
*.[oa] *~  # Gedit
.*.sw[po]  # Vim
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

#### jekyll https://jekyllrb.com/tutorials/using-jekyll-with-bundler/#commit-to-source-control
_site/
.sass-cache/
.jekyll-cache/
.jekyll-metadata
.bundle/
vendor/

#### virtual machine crash logs, see http://www.java.com/en/download/help/error_hotspot.xml
hs_err_pid*
```

## Add, Commit & Push

```bash
# git add all files 
git add .

# commit
git commit -m ""

git push origin main
```

## Branch

```bash
# list branch list
git branch -a

# change the default branch
git config --global init.defaultBranch {branchName}

# basic branching and merging
git checkout -b iss53
# Switched to a new branch "iss53"
# do modifying and add commit things

#mergin
git checkout main
# Switched to branch 'master'
git merge iss53
# merge iss53 to main
```

### 跟远程分支相关

```bash
# 要clone远程仓库时，如果想要特定分支时，先clone整个仓库，在切换到对应分支.以MaxKB为例
git clone https://github.com/1Panel-dev/MaxKB

# 查看远程有哪些分支
git branch -a

# 新建本地分支，链接远程分支
git checkout -b release-2.0 origin/release-2.0
```

- reference

  - [Change from master to a new default branch git](https://stackoverflow.com/questions/51274430/change-from-master-to-a-new-default-branch-git)
  - [How to set the default branch in GitHub.com?](https://stackoverflow.com/questions/11334045/how-to-set-the-default-branch-in-github-com)
  - [Git Branching - Basic Branching and Merging](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)

## Recovery

### For Entire Folder

```bash
git reset --hard # discard all changes
git clean -f -d #remove untracked
git clean -f -d -x # above plus ignored file
```

### For File

```bash
# last commit
git checkout filename

# one commit
git log
# choose one commit to recover
git checkout --HEAD filename
```

### For Commit point

```bash
#TODO
git reset
```

‍
