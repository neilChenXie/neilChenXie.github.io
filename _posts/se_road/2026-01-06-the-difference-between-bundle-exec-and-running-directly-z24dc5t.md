---
title: bundle exec与直接运行的差异
date: '2026-01-06 17:02:58'
permalink: /post/the-difference-between-bundle-exec-and-running-directly-z24dc5t.html
tags:
  - jekyll
  - bundle
  - ruby
categories:
  - Software Development｜软件开发
layout: post
published: true
---



## 摘要

以`jekyll serve`​为例，它默认使用的系统的相关包和环境。而`bundle exec Jekyll serve`​是使用`Gemfile.lock`里申明的包的版本来运行。

当系统的包的版本与`Gemfile.lock`​中不一致时，特别是系统的版本比`Gemfile.lock`里的版本高时，会报错。

所以，推荐使用`bundle exec Jekyll serve`

## **案例：**

通过bundle install生成的Gemfile.lock bigdecimal (3.3.1)，运行jekyll serve提示现在bigdecimal 版本为4.0.1，能怎么提升bundle install 生成bigdecimal的版本吗？

### **AI答案：**

通过 `bundle update`​ 后，[Gemfile.lock](vscode-file://vscode-app/Applications/Visual%20Studio%20Code.app/Contents/Resources/app/out/vs/code/electron-browser/workbench/workbench.html)

 中的 `bigdecimal`​ 仍然是 3.3.1，因为它是间接依赖（通过 `sass-embedded`​ → `google-protobuf`​ → `bigdecimal`​），而 `google-protobuf`​ 的当前版本（4.33.2）要求 `bigdecimal (~> 3.1)`，不支持 4.x 版本。

#### 原因分析

- ​`bigdecimal`​ 4.0.1 是 Ruby 3.4+ 的标准库版本，但作为 gem，它受上游依赖（如 `google-protobuf`）的版本约束限制。
- 你的 Ruby 版本是 3.3.5，系统可能有预装的 `bigdecimal`​ 4.0.1，但 `bundle` 使用的是锁定的 3.3.1 版本。
- 如果运行 `jekyll serve`​ 时提示 4.0.1，可能是因为未使用 `bundle exec`，导致加载了系统 gem 而非 bundle 的版本。

#### 解决方案

1. ​**始终使用** **​`bundle exec`​**：

   - 运行 `bundle exec jekyll serve`​ 而非 `jekyll serve`，确保使用 bundle 安装的 gem 版本（3.3.1），避免与系统 gem 冲突。
2. ​**如果必须升级到 4.x**：

   - 等待上游依赖（如 `google-protobuf`​ 或 `sass-embedded`​）更新以支持 `bigdecimal`​ 4.x。目前无法通过 `bundle install`​ 或 `bundle update` 强制升级，因为会违反依赖约束。
   - 如果坚持，可以在 Gemfile

     中添加 gem 'bigdecimal', '>= 4.0.0'

     ，但这可能导致 bundle 失败或兼容性问题，不推荐。
3. ​**验证版本**：

   - 运行 `bundle exec gem list bigdecimal` 检查 bundle 使用的版本。
   - 如果仍有提示问题，请提供完整的错误日志以进一步诊断。

使用 `bundle exec` 后，项目应正常运行，无需担心版本冲突。
