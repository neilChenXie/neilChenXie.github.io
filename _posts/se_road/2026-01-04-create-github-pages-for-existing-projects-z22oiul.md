---
title: ''
date: '2026-01-08 15:26:36'
permalink: /post/create-github-pages-for-existing-projects-z22oiul.html
layout: post
published: true
---



## 思路

通过`jekyll new myblog`生成必要的文件，再将这些文件Copy到现有项目的指定分支下。

然后配置Github仓库的pages设置、项目CNAME文件、域名供应商的解析。

## Setup步骤

### 一、新建jekyll博客必要文件

1. ​`jekyll new myblog`

   如果卡住了，直接`Ctrl+c`​，进入目录，运行`bundle install`安装必要的Ruby包。
2. 运行`Jekyll serve`，验证是否正常编译
3. 访问`localhost:4000`验证可正常访问

### 二、将文件Copy到对应项目下

### 三、Github仓库配置

#### 配置Github Actions

**启用项目的 GitHub Pages**：进入你的项目仓库，点击 **Settings** 选项卡。向下滚动找到 **Pages** 部分，在 **Source** 下选择一个分支（通常是 `main`​或 `gh-pages`​）后点击 **Save**。完成后，你就可以通过 `https://<username>.github.io/<projectname>`这个地址访问这个站点了。

使用Github Actions是更主流的方法

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104145439-u9uhmth.png)

Github有默认的Jekyll部署配置文件，实质是在项目下增加`.github/workflows/jekyll-gh-pages.yml`文件

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104150608-869n1n5.png)

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104150745-hzswk4g.png)

配置文件中，只需要注意编译的分支名字

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104150931-z27xap9.png)

#### Github Action编译Debug

相关编译与部署信息可在项目的`Actions`标签页看到详情。

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104152407-w8qxi3r.png)

### 四、项目文件变更

在项目目录下增加CNAME文件。

注意因为第三步直接在Github网站增加了`.github/workflows/jekyll-gh-pages.yml`文件，所以，先执行git pull，再执行git add、git commit、git push。

CNAME文件中，只能写一个域名，不用http、www开头，即与阿里云等网站买的域名一致。

比如我的域名就是chenxie.cc

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104152244-nnc13fq.png)

### 五、域名提供商配置

以阿里云为例，进入`域名与网站`工作台。（本教程不讲域名购买）

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104151521-uciote3.png)

选择要使用的域名，点击进去，选择域名解析

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104151609-fiq4ric.png)

增加`@`​和`www`​两条记录，注意记录值无论是哪个Github项目，都填`<username>.github.io`

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260104151833-qbsqmxo.png)

## 应用主题模板

### 必要性

上述完成搭建Github Page之后，网站还存在一些核心问题，比如没有文章的清单（新发布的文章根本不知道在哪），页面朴素没有前端样式等等。

通过应用Jekyll的模板可以解决以上问题。

### 核心思路

目前网上的主题虽然很fashion，但是同时运用了node等前端技术，导致部署难度较大，比如我尝试了Chirpy主题，本地尝试都OK了（需要跑`npm install`)但是上传Github之后，卡在了调试Github Actions。

最终，我决定用回我博客使用的Cayman主题，随着我过去的更新，标签汇聚页、文章目录、移动端自适应等功能都具备了，而且部署简单，用Github Page设置中的Jekyll默认配置文件即可。

但是，我有另外一点想尝试，目前我有两个内容网站都在复用**[jekyll-cayman-theme-improved](https://github.com/neilChenXie/jekyll-cayman-theme-improved)** 这个Jekyll博客框架，我是否能在两个项目中，都有对应的分支（比如cayman-theme分支），进行框架的优化，并且同步回**jekyll-cayman-theme-improved**这个仓库，每次一个项目更新的框架，其他项目可以顺利更新部署。

同时，以上的想法，也作为Git与Github学习的实战项目。

### 整体策略

您希望将项目A（您的实际博客）的框架升级为项目B（模板框架），并建立后续双向同步的机制，这是一个非常棒的思路，能有效提升维护效率。下面为您规划一个清晰可靠的分支管理和协作方案。

整个方案的核心是​**将项目B（模板框架）作为项目A（您的博客）的上游仓库**。项目A将包含两部分独立的内容：您的博客内容（如文章、图片）和来自项目B的框架代码。通过精心的分支规划，我们可以实现初始迁移和后续双向更新。

下表概述了为实现您的目标，在两个项目中需要建立的核心分支及其职责：

|项目|分支名称|主要职责|
| ------| ----------| ----------------------------------------------------|
|**项目A (您的博客)**|​`main`|存放稳定、可发布的博客版本（包含最终内容和框架）。|
||​`content`|独立管理您的博客内容（如 `_posts`, 图片等）。|
||​`template-projectA`|用于测试和集成从项目B获取的最新框架更新。|
|**项目B (模板框架)**|​`main`|存放稳定版本的模板框架代码。|
||​`template-projectA`|接收从项目A反馈回来的框架优化和改进。|

---

好的，这是一个非常典型的项目管理场景：将一个项目（项目B，模板）的通用功能应用到另一个项目（项目A，博客内容），并希望未来能将A中对模板的改进反馈回B。使用 `git` 可以非常优雅地处理这个需求。

核心思路是：**在你的博客项目A中，将模板项目B添加为一个“远程仓库”（remote），然后通过一个专门的分支来跟踪和合并B的更新。**

下面是具体的分支管理策略和操作步骤：

### 操作流程

我将这个过程分为两个阶段：**首次整合** 和 **后续维护**。

---

#### 阶段一：首次将项目B整合进项目A

假设你的项目A在本地的 `project-a` 文件夹中。

1. **为项目A添加一个指向项目B的远程仓库**  
   在你的项目A的本地仓库中，执行以下命令。我们给这个远程仓库起个名字，比如 `template_remote`。

   ```bash
   cd /path/to/project-a
   git remote add template_remote https://github.com/user/project-b.git
   ```

   - ​`template_remote` 是你为项目B起的别名，可以自定义。
   - 将 `https://github.com/user/project-b.git` 替换为你的项目B的实际Git地址。
2. **抓取项目B的所有更新**

   ```bash
   git fetch template_remote
   ```

   这个命令会把项目B的所有分支和提交历史都下载到你的本地，但不会修改你当前的工作区。
3. **创建一个新的** **​`template-projectA`​**​ **分支来跟踪项目B**  
   这个新分支将完全基于项目B的 `main` 分支创建。

   ```bash
   git checkout -b template-projectA template_remote/main
   ```

   - ​`template-projectA` 是新分支的名字。
   - ​`template_remote/main`​ 指的是我们刚刚抓取下来的项目B的 `main` 分支。
   - 执行完后，你的工作目录会切换到 `template-projectA` 分支，内容和项目B一模一样。
4. **将新的模板框架合并到你的主分支**  
   现在，最关键的一步来了：将 `template-projectA`​ 分支的内容合并到你的 `main` 分支。

   ```bash
   git checkout main
   git merge template-projectA --allow-unrelated-histories --squash
   ```

   - ​`--allow-unrelated-histories` 参数是必需的，因为项目A和项目B有各自独立的提交历史，Git默认不允许合并这样两个没有共同祖先的分支。
   - ​`--squash`：将子仓库的所有提交历史压缩为一个提交，避免主仓库的提交历史过于冗长（推荐使用）。若不添加该参数，主仓库会保留子仓库的完整提交历史。
   - **解决冲突**：这次合并几乎肯定会产生大量冲突（比如 `_config.yml`​, `Gemfile`​, `index.html`​ 等）。你需要**手动解决**这些冲突。

     - 对于配置文件（`_config.yml`），通常保留项目A的设置（如博客标题、URL等），但需要加入项目B模板所需的配置项。
     - 对于布局文件，大部分可以直接采用 `template-projectA` 分支（即项目B）的版本。
     - **关键**：确保不要删除你的 `_posts` 文件夹和文章内容！在解决冲突时，要保留这些属于项目A的核心内容。
5. **提交合并结果**  
   解决完所有冲突后，提交这次巨大的合并。

   ```bash
   git add .
   git commit -m "feat: Integrate Jekyll template from project B"
   ```

至此，你的项目A的 `main` 分支就成功换上了项目B的框架，并且保留了原有的文章内容。

---

#### 阶段二：后续日常维护

##### 场景1：项目B（模板）有了更新，你想同步到项目A

1. **更新** **​`template-projectA`​**​ **分支**：  
   切换到 `template-projectA` 分支，拉取项目B的最新代码。

   ```bash
   git checkout template
   git pull template_remote main
   ```
2. **合并到主分支**：  
   切换回 `main`​ 分支，将 `template-projectA` 分支的更新合并进来。

   ```bash
   git checkout main
   git merge template-projectA
   ```

   这次合并可能还会有冲突，但通常会比第一次少得多。解决冲突后提交即可。

##### 场景2：你在项目A中优化了模板，想把改动贡献回项目B

1. **在项目A中提交模板改动**：  
   确保你的改动是在一个独立的 commit 中，并且有清晰的说明。例如，你在 `main` 分支上修复了一个CSS bug。
2. **将这个改动应用到** **​`template`​**​ **分支**：  
   使用 `git cherry-pick` 命令，可以精确地将某一个 commit “复制”到另一个分支。

   ```bash
   git checkout template-projectA
   git cherry-pick <commit_hash_of_the_fix>
   ```

   - ​`<commit_hash_of_the_fix>`​ 是你在 `main` 分支上修复模板的那个提交的哈希值。
3. **将更新推送回项目B**：  
   现在 `template-projectA` 分支包含了你想贡献回去的改动，直接推送到项目B的远程仓库。

   ```bash
   git push template_remote template-projectA:template-projectA
   ```

   - 这行命令的意思是：将本地的 `template-projectA`​ 分支推送到名为 `template_remote`​（即项目B）的 `template-projectA` 分支。
   - 如果**你没有项目B的直接推送权限**，可以先推送到你自己的**fork**，然后通过**Pull Request**的方式贡献回去。

### 总结

|分支 (`project-a`)|用途|更新来源|
| :----------| :-----------------------------------------------| :---------------------------|
|​**​`main`​**|部署到Github Pages的最终版本，包含内容和框架。|合并自 `template-projectA`​ 分支和 `content` 分支。|
|​**​`template-projectA`​**|专门跟踪项目B（模板）的更新。|从 `template_remote` (项目B) 拉取。|
|​**​`content`​**|(可选) 专门用于撰写和管理文章、图片等内容。|日常写作。|

这种方法的最大好处是**关注点分离**：

- 内容和框架的演进在逻辑上是分开的。
- ​`git` 负责处理合并和历史追踪，清晰明了。
- 你可以随时从项目B获取更新，也可以随时向项目B贡献代码，两个项目可以健康地协同发展。

---

接下来，我们可以讨论：

1. 如何为这个流程编写一个简单的自动化脚本。
2. 如果你在合并时遇到具体的冲突，我们可以一起分析如何解决。
3. 探讨如何使用 `git submodule`​ 作为另一种替代方案（但通常我更推荐上述的 `remote`​ + `branch` 策略，因为它更灵活）。

### bundle exec与直接运行的差异[^1]

> 以`jekyll serve`​为例，它默认使用的系统的相关包和环境。而`bundle exec Jekyll serve`​是使用`Gemfile.lock`里申明的包的版本来运行。

> 当系统的包的版本与`Gemfile.lock`​中不一致时，特别是系统的版本比`Gemfile.lock`里的版本高时，会报错。

> 所以，推荐使用`bundle exec Jekyll serve`

[^1]: # bundle exec与直接运行的差异

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
