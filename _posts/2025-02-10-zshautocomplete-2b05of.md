---
title: zsh-autocomplete终端自动补全
date: '2025-02-10 11:46:15'
permalink: /post/zshautocomplete-2b05of.html
tags:
  - MacOS
  - shell｜脚本
categories:
  - Software Development｜软件开发
layout: post
published: true
---





# 摘要

- 安装

  ```bash
  brew install zsh-autocomplete
  #Add at or near the top of your .zshrc file (before any calls to compdef):
  source $HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
  ```

  - [homebrew install instruction](https://formulae.brew.sh/formula/zsh-autocomplete)
  - [github source code](https://github.com/marlonrichert/zsh-autocomplete)
- 配置

  add the code shown to your `.zshrc`​ file and modify it there, then restart you shell.

  ```bash
  # make it work like in an Ubuntu Bash 
  bindkey              '^I'         menu-complete
  bindkey "$terminfo[kcbt]" reverse-menu-complete
  ```
- 常见问题

  ​`zsh compinit: insecure directories, run compaudit for list.`​

  ​`Ignore insecure directories and continue [y] or abort compinit [n]`​

  ```bash
  # press n, then
  compaudit
  # show insecure directories
  # /opt/homebrew/share/zsh/
  # /opt/homebrew/share/zsh/site-functions/

  # based on the lists above
  sudo chmod -R 755 /opt/homebrew/share/zsh/site-functions/
  sudo chmod -R 755 /opt/homebrew/share/zsh/

  sudo chown -R root:root /opt/homebrew/share/zsh/site-functions/
  sudo chown -R root:root /opt/homebrew/share/zsh/
  ```

# 详细记录
