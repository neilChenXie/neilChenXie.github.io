---
title: Github & git
date: '2025-01-16 10:03:25'
permalink: /post/github-7oraf.html
tags:
  - git
  - github
categories:
  - Software Development｜软件开发
layout: post
published: true
---



## 创建仓库

### SSH

```bash
#SSH
#Generate your key with your email.
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
#all key file under ~/.ssh/
#id_rsa is private key, don't give it to anyone.  
#id_rsa.pub is public key for GitHub

# different location to generate key Files
ssh-keygen -t rsa -f ~/Documents/sshkey/{name}
```

将文件夹下的id_rsa.pub文件内容加入到github中。

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20251215141126-84wb4jc.png)

### Init & Config

```bash
#进入项目文件夹
git init

#Config
# name,email 涉及contribution统计
git config --global user.name "Chen Xie"
git config --global user.email "chenxie2016@163.com"

# 查看设置
git config --list

# 设置
# check the Remote URL AND modify the Remote URL
git remote -v
git remote set-url origin <NEW_GIT_URL_HERE>

# simple for current branch, matching for all branches
git config --global push.default simple

# sensitive to up/lower case
git config core.ignorecase false
```

### Add, Commit & Push

```bash
# git add all files 
git add .

# commit
git commit -m "first commit"

git push origin main
```

## .gitignore

### File Content

#### Mac&Windows Related

```bash
# Mac_OS
.DS_Store
.Spotlight-V100
.Trashes
._*

# Windows
Thumbs.db
desktop.ini
```

#### Editor&IDE Related

```bash
*.[oa] *~  # Gedit
.*.sw[po]  # Vim
# Eclipse
.project
.classpath
.settings
.metadata

# VS Code
.vscode/
*.code-workspace

#IDEA
.idea/
```

#### Nodejs Related

```bash
# nodejs
node_modules/
dist/
build/
.env
.env.local
.env.*.local
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
```

#### Java Related

```bash
# java compile
*.class
target

# Mobile Tools for Java (J2ME)
.mtj
.tmp/
# virtual machine crash logs, see http://www.java.com/en/download/help/error_hotspot.xml
hs_err_pid*
```

#### Jekyll Related

```bash
# jekyll https://jekyllrb.com/tutorials/using-jekyll-with-bundler/#commit-to-source-control
_site/
.sass-cache/
.jekyll-cache/
.jekyll-metadata
.bundle/
vendor/
```

### Remove files which are tracked before it is added to .gitignore

```bash
git rm -r --cached .
git add .
```

- reference: [How do I make Git forget about a file that was tracked, but is now in .gitignore?](https://stackoverflow.com/questions/1274057/how-do-i-make-git-forget-about-a-file-that-was-tracked-but-is-now-in-gitignore)

## Branch

### 本地基本操作

```bash
# list all branches
git branch -a

# change the default branch
git config --global init.defaultBranch {branchName}

# basic branching and merging
git checkout -b iss53
# Switched to a new branch "iss53"
# do modifying and add commit things

# Mergin
git checkout main
# Switched to branch 'master'
git merge iss53
# merge iss53 to main

# Delete
git branch -d [branch-name] #can delete if the branch is merged
git branch -D [branch-name] #can delete without merging the branch
```

### 获取远程仓库的分支

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

### 本地分支与远程仓库分支交互

```bash
# Check the relationship between local-branch and remote-branch
git branch -vv

# Add remote Repo
git remote add <repo-nickname> <repoUrl>
# Delete remote Repo
git remote remove <repo-nickname>

# set the relationship between local-branch and remote-branch
git branch --set-upstream-to=<RepoName>/<remote-branch-name> <local-branch>
#or Use -u when push
git push -u <remote> <local_branch>

# Delete local-fetched remote-branches
git branch -d -r origin/[remote-branch-name]

# Delete remote branches in Repository
git push origin --delete [remote-branch-name]

# Delete Fetched Remote Branches
git fetch --prune # Auto-delete branches which are deleted in remote repository
```

### 当分支提交了Commit，主干也有新的Commit（`git rebase -i`）

参考：

- [git rebase: 人生无法重来，但代码可以！](https://www.bilibili.com/video/BV1Xb4y1773F)
- [git rebase 情景图表+代码演示](https://www.bilibili.com/video/BV1GpqsYREeP)

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20251216155650-jrpf1y0.png)

结论，在此情况下，使用`git rebase`​好过`git merge main`。

<span data-type="text" style="color: var(--b3-font-color8);">黄金原则：不要使用rebase处理已经被其他人引用的提交。</span>

引申，`git rebase -i`常用命令：pick、rework、squash、drop

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20251216160909-8nle2oc.png)

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
