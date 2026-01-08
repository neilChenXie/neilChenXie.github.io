---
title: 本地Git不同分支对应不同远程仓库
date: '2026-01-05 10:56:00'
permalink: >-
  /post/different-branches-of-local-git-correspond-to-different-remote-warehouses-z1ifyjd.html
tags:
  - git
  - github
categories:
  - Software Development｜软件开发
layout: post
published: true
---



## 摘要

### 场景

博客模板：我现在有个基于Github Pages的Jekyll博客项目A已经提交了很多年，有很多Commit；有个项目B是Jekyll博客模板框架，也更新了很多年。现在我希望能把项目A的博客框架换成项目B的，同时，后续我在项目A要优化框架时，调试完，也把最新的更新推给项目B。我应该怎么规划管理项目A和项目B的分支。

其他场景如中间件等

### 经验

注意：每个本地分支只能对应一个远程仓库分支。

```bash
#设置不同仓库的别名
git remote add [RepoName] [RepoURL]

# 将本地分支推送到指定仓库的分支
git push -u [RepoName] [local-branch-name]:[remote-branch-name]
# 案例
git push -u cayman cayman-theme:digital-scrapbook

# 查看本地分支对应的仓库分支
git checkout [local-branch-name]
git branch -vv
```

## 执行过程

当然可以。Git 支持将一个项目中不同的分支推送到不同的远程仓库，这对于管理框架或模板等具有不同用途或不同发布周期的代码非常有用。

下面是一个快速对比不同方案核心特点的表格，方便你快速了解：

|方案|核心思路|优势|适用场景|
| ------| ------------------------------------------------------------------------| ------------------------------------------------| ---------------------------------------------------------|
|**独立远程仓库**|为不同的远程仓库起不同的别名（如 `origin_fw`​, `origin_proj`），分别推送指定分支。|​**灵活精准**，控制力最强，分支与仓库的映射关系清晰。|框架代码与业务代码完全独立，有不同维护周期和权限。|
|**单远程多上游**|只使用一个远程别名（如 `origin`），但为其配置多个URL，一次推送可至多个仓库。|​**操作简便**​，一次`push`即可同步到多个仓库，减少重复操作。|需要将代码同时备份或同步到多个平台（如GitHub和Gitee）。|

### 💁 方案一：为不同仓库配置独立远程别名

这是最常用、控制粒度最细的方法。你可以为框架仓库和项目仓库分别设置一个简短的远程别名，然后分别推送对应的分支。

1. ​**查看现有远程仓库**​：使用 `git remote -v`查看当前关联的远程仓库。
2. ​**添加新的远程仓库**​：使用 `git remote add <别名> <仓库URL>`命令为另一个仓库（比如框架仓库）添加一个远程地址。

   ```bash
   # 假设 origin 指向你的主项目仓库
   # 添加框架仓库，并起一个别名，比如 framework-upstream
   git remote add framework-upstream https://git.example.com/your-company/framework.git
   ```
3. ​**推送到指定仓库**：推送时，明确指定远程仓库别名和分支名。

   ```bash
   # 将本地的 framework-template 分支推送到框架仓库的 main 分支
   git push framework-upstream framework-template:main

   # 将本地的 project-dev 分支推送到主项目仓库的 dev 分支
   git push origin project-dev:dev
   ```
4. ​**设置分支上游（可选但推荐）** ​：为本地分支设置默认推送的远程仓库，之后可以直接用 `git push`。

   ```bash
   # 切换到 framework-template 分支
   git checkout framework-template
   # 为其设置默认推送到 framework-upstream 仓库的 main 分支
   # 解释：git push -u [RepoName] [local-branch-name]:[remote-branch-name]
   git push -u framework-upstream framework-template:main

   ```

### 💁 方案二：为一个远程别名配置多个URL

如果希望将某些分支同时推送到多个仓库（例如既推送到内部框架仓库，也推送到GitHub备份），可以为一个远程别名配置多个URL。

1. ​**添加多个URL**​：使用 `git remote set-url --add <别名> <新仓库URL>`。

   ```bash
   # 为 origin 添加第二个推送地址
   git remote set-url --add origin https://github.com/your-account/backup-framework.git
   ```
2. ​**验证配置**​：使用 `git remote -v`​查看，会发现 `origin`​的 `push`URL 有两个。
3. ​**一次性推送**​：之后执行 `git push origin main`，这次提交会自动推送到两个仓库。

### 💡 操作建议与注意事项

- ​**权限管理**：确保你对目标远程仓库有写入权限。
- ​**分支命名清晰**​：使用清晰的命名（如 `framework-v2`​、`project-a-feature`）避免混淆。
- ​**非强制推送慎用**​：除非你非常确定要覆盖远程历史，否则谨慎使用 `git push --force`​。如果必须使用，更安全的选项是 `git push --force-with-lease`。
- ​**首次推送使用**​ **​`-u`​**​：在第一次推送分支到新远程仓库时，使用 `-u`​或 `--set-upstream`​选项可以建立本地分支与远程分支的跟踪关系，之后在该分支上直接使用 `git push`即可。

希望这些方案能帮助你优雅地管理框架和项目代码。如果你的框架和业务代码在同一个仓库中，需要考虑如何分离，或者有其他具体场景，我们可以继续深入探讨。

## 针对博客模板场景

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
