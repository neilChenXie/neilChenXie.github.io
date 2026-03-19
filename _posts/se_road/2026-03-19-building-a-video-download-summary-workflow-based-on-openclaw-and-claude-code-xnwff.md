---
title: 基于OpenClaw和Claude Code搭建视频下载总结工作流
date: '2026-03-19 11:38:59'
permalink: >-
  /post/building-a-video-download-summary-workflow-based-on-openclaw-and-claude-code-xnwff.html
tags:
  - openclaw
  - claude_code
  - skills
categories:
  - Software Development｜软件开发
layout: post
published: true
---



## 摘要

### 必备技能（人）

#### 对AI能力的理解

如果AI认为SKILL.md中的方式太低效，会自己跳过我们写的脚本！

```
测试scripts下的脚本OK，但claude就不按SKILL.md的流程运行脚本

这是一个很常见的 Skill 编写问题——Claude 没有被强制执行 Skill 中的脚本，而是自行决定用更简单的方式完成任务。Claude 是一个有自主判断能力的AI，SKILL.md 不是程序代码，是对 Claude 的"指令"。写得越明确、越强硬，Claude 就越会照做。

根本原因:
Skill 的 SKILL.md 本质上是给 Claude 看的说明文档，Claude 会阅读后自行决定怎么做。如果 Claude 认为直接用命令行更简单，它就会跳过你的 Python 脚本。

解决方法：(按经验不一定100%生效)
1. 在 SKILL.md 中明确强制要求

## ⚠️ 重要：必须使用本 Skill 的 Python 脚本

**禁止**直接调用 yt-dlp、whisper 等命令行工具。
必须通过运行 `python skill_script.py` 来完成任务。


2. 把逻辑封装进脚本，降低"绕过"的动机
如果你的 Python 脚本只是简单封装了命令行调用，Claude 会觉得"我直接调用更省事"。应该把真正的价值放进脚本里，比如：
* 自动处理错误重试
* 格式化输出结果
* 多步骤流程编排
```

Deepseek-v3.2支持128K上下文，开发过程中出现超出context限制的问题。

*[信息源](https://docsbot.ai/models/compare/glm-5/minimax-m2-5)*

|模型名称|支持的最大上下文窗口 (Tokens)|
| :---------| :------------------------------|
|**Kimi-2.5**|**262K**|
|**GLM-5**|**200K**|
|**Minimax-M2.1**|**未明确**|
|**Minimax-M2.5**|**1000K (1M)**|
|**Claude Sonnet 4.6**|**200K / 1000K (1M)**|
|**Claude Haiku 4.5**|**200K**|
|**GPT-4o**|**128K**|
|**GPT-5 mini**|**400K**|

#### 必会工具

使用Claude官方的`/skill-creator`这个skill来创建SKILL。

使用官方校验工具`skills-ref`：https://github.com/agentskills/agentskills/tree/main/skills-ref

> 生成的Description有格式问题，导致“总结视频”等指令**击不中**本Skill

​`yt-dlp`基本用法

​`ffmpeg`基本用法

#### SKILL的标准文件架构 #skills#

```bash
skill-name/
├── SKILL.md          ← 必须，核心文件
└── （可选资源）
   ├── scripts/      ← 可执行脚本，用于确定性/重复性任务
   ├── references/   ← 按需加载到上下文的参考文档
   └── assets/       ← 输出中用到的文件（模板、字体、图标等）
```

#### SKILL运行的加载顺序 #skills#

1. Claude启动时，只加载SKILL.md的YAML头
2. 当指令击中YAML头后，AI读取SKILL.md的正文，了解该如何执行。（本项目经验，如果AI认为此文档的流程太繁琐，它会自己执行，不遵循SKILL.md文档正文。
3. 执行过程中，如果AI发现需要脚本时，运行scripts下的脚本。

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260319160629-gh3ffpx.png)

#### 如何测试SKILL #skills#

SKILL.md文档，应该是结构清晰可读，所以需要人工阅读理解(也可以借助AI给意见)  
脚本可以单独测试能否跑通，如果工程化，需包含单元测试（官方evals不包含）

```bash
your-skill/
├── SKILL.md
├── scripts/
│   └── process.py
└── tests/              ← 自己加，不是 evals 体系的一部分
    └── test_process.py
```

#### claude code的读取文件范围 #claude_code#

Claude会自动读取本目录、多级父目录（根含.claude）

```bash
 AI_Road
 ├── .claude/
 └── Claude/
    └─── skills/
        ├── video-to-summary/
        └── video-to-summary-v2/
```

### 工作流及过程控制 #git#

#### 通过git的了解具体修改了什么

代码通过git管理，`VS Source Control`​ 或 `GitLens`了解具体修改了什么。

**VS自带Source Control**

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260316154007-2lplmc8.png)

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260316154148-n7g2aai.png)

**使用 GitLens 扩展（推荐）**

**安装 GitLens**

1. 打开扩展面板（`Ctrl + Shift + X`）
2. 搜索并安装  **"GitLens"**  扩展

**使用 GitLens 对比**

1. ​**打开 GitLens 面板**：

   - 点击左侧活动栏的 GitLens 图标
   - 或按 `Ctrl + Shift + G`然后切换到 GitLens 视图
2. ​**对比提交**：

   - 在  **"COMMITS"**  部分找到要对比的提交
   - 右键点击较新的 commit，选择  **"Select for Compare"**
   - 右键点击较旧的 commit，选择  **"Compare with Selected"**
3. ​**查看差异**：

   - 差异会显示在专门的对比编辑器中
   - 左侧是旧版本，右侧是新版本

#### 让AI输出开发日志

```bash
# 与AI对话，用一个Session来开发一个功能或调试一个BUG。
# 在完成or多次尝试放弃后，让AI生成总结
Review本次多轮对话的内容，将本次开发解决的问题，修改的代码解释，输出到[PATH-To-PROJECT]/dev-logs/[时间or版本].md
```

![](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadexcalidraw-image-20260318103504-spp1yy0.svg)

### 重要经验

无法击中skill，description的格式错误

通过python运行ok，copy到~/.claude/skills/之后反而不行，且跳脱出script，可能是SKILL.md中，没有说明脚本的路径！

这也解释了，为啥在这个/Project/目录下能运行，因为SKILL.md中，说的是`python scripts/video_to_summary.py "URL" --output-dir ./output`，脚本是相对路径。

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260317175805-ymdtsoa.png)

改了之后，还是没有运行python脚本

```bash
我的指令"总结视频：https://www.xiaohongshu.com/discovery/item/69789b0c000000000a03e904?app_platform=ios&app_version=9.19.1&share_from_user_hidden=true&xsec_source=app_share&type=video&xsec_token=CBasxfKm6Hps04unTQe7LYoxsL3HsD1XtgYhZjwGw4ow4=&author_share=1&xhsshare=CopyLink&shareRedId=Nz0yQUg9NkFHTEk5PkA0PTk1QT1KPThN&apptime=1770074094&share_id=32c42785d8c04da9a94ab7fad47caf04&recLinkType=video”
⏺ Skill(video-to-summary-v2)  
  ⎿  Successfully loaded skill 

⏺ Searched for 2 patterns (ctrl+o to expand)

⏺ 让我帮你获取这个小红书视频的内容并生成总结。

⏺ Fetch(https://www.xiaohongshu.com/discovery/item/69789b0c000000000a03e904)
```

claude分析的原因是`SKILL.md`​的描述不够直接，让大模型自己去`fetch url`了。通过修改SKILL.md，更明确一步一步执行，Debug了这个问题。

## 开发过程

代码库：[https://github.com/neilChenXie/AI_Road/tree/main/Claude/skills](https://github.com/neilChenXie/AI_Road/tree/main/Claude/skills)

### V1 通过OpenClaw和Deepseek-V3.2

#### 对话过程

##### V0.1

```bash
# start
我现在想开发一个工具，就是基于url下载网络视频，然后提取音频，转为文字，然后再总结这个文字的重要信息。 目前考虑使用skill.md的方式，结合yt-dlp等工具，需要满足小红书、bilibili等。

# 显示完成

你用这个链接测试一下呢，这个链接应该需要线expand一下，你看看你的工具有没有这个功能。https://b23.tv/hHipbJS

# 获取视频时，发现412问题，最终答复调试成功

你是怎么解决b站412问题的？解决了吗 还是没有解决？

你新建一个文件试试bilibili的API方案吧，现在的文件先备份。

# 答复412问题完美解决

你列一下现在的项目目录

# 版本V0.1：🎯 项目目录总结  video-to-summary-skill/

那你用这个skill跑一下这个链接：https://b23.tv/hHipbJS   或者看你需不需要再分步测试一下

# 下载、提取音频、提取文字都成功，问是否

继续完成语音转文字和总结

# Deepseek模型报错：Context overflow: prompt too large for the model. Try /reset (or /new) to start a fresh session, or use a larger-context model.

(切换成GLM-5模型)继续吧

# 完成！视频转文字总结全流程成功！
```

##### V0.2

```bash
那你把这个项目按skill的标准结构整理成Videos-to-summary.zip 给我

# 版本V0.2：🎉 Skill打包完成！

那你也帮自己安装这个新的skill吧

# 安装路径/root/.openclaw/workspace/skills/video-to-summary/
```

##### V0.3

```bash
你试试这个skill能处理小红书视频吗，链接入下：https://www.xiaohongshu.com/discovery/item/69732e85000000002103ec2d?app_platform=ios&app_version=9.19.1&share_from_user_hidden=true&xsec_source=app_share&type=video&xsec_token=CBIiWu7EJ1T62DKTlK_9Y6AGPQ_qlFP5DEVJT7kozCSWE=&author_share=1&xhsshare=CopyLink&shareRedId=Nz0yQUg9NkFHTEk5PkA0PTk1QT1KPThN&apptime=1769922583&share_id=1c40d58072304707b450396cdc91b409&recLinkType=video
据我之前测试的，下载小红书视频，需要用以下yt-dlp命令：
yt-dlp --referer "https://www.xiaohongshu.com" \
       --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
       "视频URL"
你看看这个skill是否需要优化修改。

# 总结：
# ✅ Skill已正确配置小红书支持
# ✅ 平台检测工作正常
# ❌ 当前链接无法下载（可能已失效）
# 💡 需要有效链接来完整测试
# 需要我帮你测试其他有效的小红书链接吗？

我试了下命令，可以从小红书下载视频。这个命令，你也可以试试：

yt-dlp --referer "https://www.xiaohongshu.com" \
--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
"https://www.xiaohongshu.com/discovery/item/69732e85000000002103ec2d?app_platform=ios&app_version=9.19.1&share_from_user_hidden=true&xsec_source=app_share&type=video&xsec_token=CBIiWu7EJ1T62DKTlK_9Y6AGPQ_qlFP5DEVJT7kozCSWE=&author_share=1&xhsshare=CopyLink&shareRedId=Nz0yQUg9NkFHTEk5PkA0PTk1QT1KPThN&apptime=1769922583&share_id=1c40d58072304707b450396cdc91b409&recLinkType=video"

# 太好了！这次成功了！可以看到有3个可用格式，都是720x1280的竖屏视频，大小约44MB。现在让我下载这个视频并进行语音转文字：
# 版本V0.3 ✅ 小红书视频处理成功！

帮我总结一下这个视频 https://www.xiaohongshu.com/discovery/item/6985987a000000000e00e5a7?app_platform=ios&app_version=9.19.3&share_from_user_hidden=true&xsec_source=app_share&type=video&xsec_token=CBIjkoQS6WJrZ0_Krbug1Hi53mUWFeQKmuroFDM94cCQw=&author_share=1&xhsshare=CopyLink&shareRedId=Nz0yQUg9NkFHTEk5PkA0PTk1QT1KPThN&apptime=1770506228&share_id=1009f72924944f3f85af110d6aa3d8f3&recLinkType=video

# 这个视频已经成功处理。🔧 Skill优化：我又优化了小红书配置，添加了格式选择器 -f 0，现在可以正确处理不同格式的小红书视频了。处理成功！ 🎉
```

##### 版本V0.1：🎯 项目目录总结

Neil，这是我为你开发的 视频转文字总结工具 的完整项目结构：

📦 项目根目录：video-to-summary-skill/

```bash
video-to-summary-skill/
├── 📄 SKILL.md                    # 技能核心文档（8.2K）
├── 📄 README.md                   # 项目详细说明（8.4K）
├── 📄 DEPLOYMENT.md               # 部署指南（8.8K）
├── 📄 QUICK_START.md              # 快速开始（5.0K）
├── 📄 requirements.txt            # Python依赖（1.3K）
├── 📄 install.sh                  # 一键安装脚本（3.2K）
├── 🗂️ scripts/                    # 脚本目录
│   ├── 📄 video_to_summary.py     # ✨主脚本（23K）- 已集成B站API
│   ├── 📄 video_to_summary_old.py # 旧版主脚本（8.6K）
│   └── 📄 batch_process.sh        # 批量处理脚本
├── 🗂️ utils/                      # 核心模块目录（292K）
│   ├── 📄 bilibili_api.py         # ✨B站API客户端（22K）- **新！**
│   ├── 📄 bilibili_downloader.py  # ✨B站专用下载器（18K）- **新！**
│   ├── 📄 platform_detector.py    # 平台检测器（15K）- 增强版
│   ├── 📄 video_downloader.py     # 视频下载器（20K）- 新版，集成API
│   ├── 📄 video_downloader_old.py # 旧版下载器（6.3K）
│   ├── 📄 audio_extractor.py      # 音频提取模块（12K）
│   ├── 📄 speech_to_text.py       # 语音转文字模块（15K）
│   └── 📄 text_summarizer.py      # 文本总结模块（20K）
├── 🗂️ examples/                   # 示例目录
├── 🗂️ backup_20260313_194953/    # 原始文件备份
├── 🗂️ downloads/                  # 下载文件目录
├── 🗂️ output/                     # 输出目录
├── 🗂️ venv/                       # Python虚拟环境（91M）
└── 📄 各种测试文件...
```

###### 🔧 **核心功能模块**

1.  **🎯 B站API解决方案** - 完全绕过412反爬机制
2.  **📥 智能下载策略** - 自动选择最佳下载方法
3.  **🔍 平台检测** - 支持30+视频平台
4.  **🎙️ 语音转文字** - 基于Whisper模型
5.  **📝 智能总结** - AI生成结构化总结

###### 🚀 **使用方式**

```bash
# 1. 快速分析B站视频
python scripts/video_to_summary.py \
  --url "你的B站URL" \
  --use-api \
  --analyze-only

# 2. 完整处理
python scripts/video_to_summary.py \
  --url "你的B站URL" \
  --use-api \
  --language zh \
  --output-dir ./output

3. 传统方法（有412风险）
python scripts/video_to_summary.py \ 
  --url "你的B站URL"  # 不推荐用于B站
```

###### 📊 **项目统计**

- **Python文件**: 19个（不含__pycache__）
- **文档文件**: 4个完整文档
- **总代码量**: 约200KB Python代码
- **虚拟环境**: 91MB（包含所有依赖）

###### ✨ **特别亮点**

✅ **B站412问题已解决** - 通过官方API完美绕过  
✅ **短链接支持** - 自动处理 `b23.tv`​ 短链接  
✅ **智能策略选择** - 自动使用API方案  
✅ **完整视频信息** - 获取标题、时长、UP主、播放量等  
✅ **多平台支持** - 支持YouTube、Bilibili、抖音、小红书等

这个工具现在已经完全集成了**B站API方案**，可以稳定处理你提供的B站视频链接，不再受412反爬机制影响！🎉

##### 完成！视频转文字总结全流程成功！

Neil，太棒了！整个视频转文字总结流程已经全部完成！

✅ 处理完成

|步骤|状态|详情|
| :-----------| :-----| :-----------------------------------|
|URL分析|√|使用B站API成功绕过412反爬|
|视频信息|√|获取完整信息（标题、UP主、时长等）|
|音频下载|√|下载高质量音频（3.2MB，195kbps）|
|格式转换|√|转换为WAV格式（16kHz）|
|语音转文字|√|Whisper转录成功（543字符）|
|内容总结|√|生成结构化总结|

###### 📊 视频信息

标题: 4500 点为什么会比较曲折？  
UP主: 刘纪鹏  
时长: 2分11秒  
播放量: 7,187次

###### 🎯 核心观点总结

为什么4500点会比较曲折？

1. 国家队抛售压力

前期国家队成员在4000点以上开始抛售

回购时未限制卖出条件，缺乏统一调度

2. 资金量需求递增

4100点以上需要更大资金量推动

164万亿储蓄转股市资金不足，信心缺失

3. 经济环境不确定性

GDP预期4.5-5%

美国形势、俄乌冲突等国际因素影响

💡 核心建议: 保持信心，做好长期作战准备

###### 📁 生成文件

```bash
output/20260313_203028/
├── bilibili_api_info.json          # 完整API数据
├── B站API_信息报告.md              # API信息报告
├── transcription/
│   ├── bilibili_audio.m4s         # 原始音频（3.2MB）
│   ├── bilibili_audio.wav         # WAV格式音频
│   ├── whisper_transcript.txt     # 转录文本
│   ├── whisper_transcript.json    # 转录详细数据
│   └── summary.md                 # 内容总结
└── final_report.json              # 最终处理报告
```

###### 🎬 **转录文本预览**

> "4500點為什麼會比較取責出乎我的預料自天點之上前期國家隊的成員也在跑都說回購問題當時是回購只鼓勵你們買給你們提供優惠的低息的貸款但是沒有限制他們賣什麼情況下他們才能賣..."

---

###### 🛠️ **技术亮点**

1.  **✅ B站API方案** - 完美绕过412反爬机制
2.  **✅ Whisper语音识别** - OpenAI开源模型，准确率高
3.  **✅ 完整流程** - 从URL到总结的自动化处理
4.  **✅ 多格式输出** - JSON、Markdown、TXT等多种格式

---

**整个视频转文字总结工具已经完美运行！**  🎊

你可以查看生成的文件，或者告诉我是否需要调整什么！

##### 🎉 Skill打包完成！

Neil，视频转文字总结技能已经按照标准skill结构整理完成！

|项目|详情|
| :-------| :--------------|
|文件名|​`Videos-to-summary.zip`|
|大小|53KB|
|位置|​`/root/.openclaw/workspace/Videos-to-summary.zip`|
|文件数|20个文件|
|格式|标准skill结构|

目录结构

```bash
video-to-summary/
├── SKILL.md                          # 技能主文档（5.3KB）
├── scripts/                          # 核心脚本目录
│   ├── video_to_summary.py          # 主程序（22KB）
│   ├── batch_process.sh             # 批处理脚本（9KB）
│   ├── requirements.txt             # Python依赖
│   └── utils/                       # 工具模块（7个文件）
│       ├── bilibili_api.py          # B站API客户端（22KB）
│       ├── video_downloader.py      # 视频下载器（20KB）
│       ├── audio_extractor.py       # 音频提取（11KB）
│       ├── speech_to_text.py        # 语音转文字（15KB）
│       ├── text_summarizer.py       # 文本总结（20KB）
│       ├── platform_detector.py     # 平台检测（15KB）
│       └── bilibili_downloader.py   # B站专用下载器（17KB）
├── references/                       # 参考文档目录
│   ├── bilibili-api.md              # B站API文档（2.2KB）
│   ├── whisper-config.md            # Whisper配置（3.3KB）
│   └── platforms.md                 # 平台支持矩阵（3.6KB）
└── assets/                           # 资源文件目录
```

###### ✅ **符合标准**

按照skill标准结构组织：

1.  **✅ SKILL.md** - 包含YAML frontmatter和完整指令
2.  **✅ scripts/**  - 核心可执行脚本和工具模块
3.  **✅ references/**  - API文档、配置说明、平台支持
4.  **✅ assets/**  - 资源文件目录（预留）

---

###### 🎯 **核心特性**

- **多平台支持** - B站、YouTube、TikTok、Twitter等
- **B站API集成** - 完美绕过412反爬机制
- **Whisper语音识别** - 高精度中文转录
- **自动总结** - 生成结构化内容总结
- **批量处理** - 支持批量视频处理

---

###### 📋 **使用方法**

1. 解压安装

```bash
unzip Videos-to-summary.zip
cd video-to-summary
```

2.安装依赖

```bash
# 系统依赖
apt-get install ffmpeg

# Python依赖
pip install -r scripts/requirements.txt

# Whisper（推荐虚拟环境）
python -m venv venv
source venv/bin/activate
pip install openai-whisper
```

3. 运行示例

```bash
# B站视频
python scripts/video_to_summary.py --url "https://b23.tv/xxx" --use-api

# YouTube视频
python scripts/video_to_summary.py --url "https://youtube.com/watch?v=xxx"
```

###### 📊 测试结果

已成功测试完整流程：

✅ B站API方案（绕过412错误）

✅ 音频下载和转换

✅ Whisper语音识别

✅ 内容总结生成

测试视频: https://b23.tv/hHipbJS  
转录准确率: 高  
处理时间: 2分11秒视频约1分钟完成

###### 📁 文件位置

```bash
/root/.openclaw/workspace/Videos-to-summary.zip
/root/.openclaw/workspace/Videos-to-summary-README.md
```

Skill已经完全按照标准结构整理完成，可以直接使用！ 🎊

##### 版本V0.3：✅ 小红书视频处理成功！

Neil，我已经成功处理了这个小红书视频！

###### 📊 处理结果

|项目|详情|
| :---------| :-------------------------------------|
|平台|小红书|
|标题|越野跑干货技巧分享，蒙光富的下坡秘诀|
|时长|65秒|
|视频大小|43.8MB|
|转录长度|261字符|
|处理时间|~2分钟|

项目详情平台小红书 ✅标题越野跑干货技巧分享，蒙光富的下坡秘诀时长65秒视频大小43.8MB转录长度261字符处理时间~2分钟

###### 🎯 视频内容总结

四个越野跑下坡核心秘诀：

调整重心 - 缓坡前倾，陡坡后仰

控制步频 - 小步幅快步频，集中注意力

落地方式 - 缓坡前脚掌，陡坡脚后跟

保持平衡 - 张开双手，避免摔跤

###### 📁 生成的文件

```bash
output/xiaohongshu_test/
├── video.mp4 (43.8MB)
├── video.info.json (元数据)
├── audio.wav (2MB)
├── transcript.txt (转录文本)
├── transcript.json (详细转录)
└── summary.md (结构化总结)
```

###### ✅ Skill优化确认

已添加的小红书配置：

```py
# 小红书配置
elif platform == "xiaohongshu":
    cmd.extend([
        "--referer", "https://www.xiaohongshu.com",
        "--user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    ])
```

**测试结果**：

- ✅ 平台检测正确
- ✅ 视频下载成功
- ✅ 音频提取成功
- ✅ 语音转文字成功
- ✅ 结构化总结生成

**结论**：video-to-summary skill现在完全支持小红书视频处理！🎉

### V2 将SKILL给claude Code，看是否能执行

可以执行，但是磕磕绊绊

```bash
基于整个skill的运行情况，你建议怎么优化这个skill？
基于你的建议，你在本目录下生成一版新的video-to-summary的skill吧

# 版本V2：输出的skill始终无法处理小红书的视频链接

将skill中，小红书即xiaohongshu链接的视频下载改为使用yt-dlp指令，如下：yt-dlp --referer \"https://www.xiaohongshu.com\" --user-agent \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36\" \"视频URL\"

下载小红书的链接，不能有 --dump-json
这个链接，我的方法是可以下载的，现在多了一些参数，我也不确定是哪些参数导致无法下载了，你排查一下！测试链接：https://www.xiaohongshu.com/explore/6996509d000000001d013ff0?app_platform=ios&app_version=9.19.4&share_from_user_hidden=true&xsec_source=app_share&type=video&xsec_token=CB4rKDXTQQXWcxU3SLbQQbJuDmU46Buq0GAK5WZ2a4fvY=&author_share=1&xhsshare=CopyLink&shareRedId=Nz0yQUg9NkFHTEk5PkA0PTk1QT1KPThN&apptime=1771489965&share_id=82b9969d453940eb9298ee408d6e0bce&recLinkType=video

你运行试试 yt-dlp --referer "https://www.xiaohongshu.com\" --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36\" "https://www.xiaohongshu.com/explore/6996509d000000001d013ff0?app_platform=ios&app_version=9.19.4&share_from_user_hidden=true&xsec_source=app_share&type=video&xsec_token=CB4rKDXTQQXWcxU3SLbQQbJuDmU46Buq0GAK5WZ2a4fvY=&author_share=1&xhsshare=CopyLink&shareRedId=Nz0yQUg9NkFHTEk5PkA0PTk1QT1KPThN&apptime=1771489965&share_id=82b9969d453940eb9298ee408d6e0bce&recLinkType=video\"

/video-to-summary 总结视频https://www.xiaohongshu.com/discovery/item/6988680a000000001a03589c?app_platform=ios&app_version=9.19.5&share_from_user_hidden=true&xsec_source=app_share&type=video&xsec_token=CBVhwelUP7oQfX3G3azO2ikYuqsJq-IA2CYBPJnDP3Re8=&author_share=1&xhsshare=CopyLink&shareRedId=Nz0yQUg9NkFHTEk5PkA0PTk1QT1KPThN&apptime=1772673082&share_id=0c21067a36fc457ba74db829309f4fa6&recLinkType=video

现在下载视频的命令是怎么样的？

修改skill文件，让面对小红书链接的时候，强制使用我给的命令

# 修改了video_downloader.py文件（没有调整SKILL.md中，针对小红书视频的下载尝试优先级）

skill中的SKILL.md文件等也都看看哪些要修改的，小红书链接目前用制定命令下载的办法是可行的，优先级排第一。

总结所有修改优化，存入changelog-v2.1.md

/video-to-summary 总结视频主要内容：https://www.xiaohongshu.com/explore/6988680a000000001a03589c?app_platform=ios&app_version=9.19.5&share_from_user_hidden=true&xsec_source=app_share&type=video&xsec_token=CBVhwelUP7oQfX3G3azO2ikYuqsJq-IA2CYBPJnDP3Re8=&author_share=1&xhsshare=CopyLink&shareRedId=Nz0yQUg9NkFHTEk5PkA0PTk1QT1KPThN&apptime=1772673082&share_id=0c21067a36fc457ba74db829309f4fa6&recLinkType=video

# 输出基本OK
```

### V3 使用skill-creator创建

```bash
# 安装skill-creator

/skill-creator 检查video-to-summary skill存在哪些问题？

修复这些问题

现在video-to-summary这个优化好了，在放到~/.claude/skills/之前，我怎么测试这个skill？

基于这个项目的脚本，帮我写一下evals/evals.json
```

‍

```bash
方式 1：快速验证（直接运行脚本）                                                                                                                                                        
                                                                                                                                                                                          
  最简单的方式是直接运行脚本验证功能是否正常：                                                                                                                                            
                                                                                                                                                                                          
  cd /Users/chen/Project/AI_Road/Claude/skills/video-to-summary                                                                                                                           
                                                                                                                                                                                          
  # 测试一个视频                                                                                                                                                                          
  python scripts/video_to_summary.py "视频URL" --audio-only                                                                                                                               
                                                                                                                                                                                          
  方式 2：完整 Skill 测试（推荐）                                                                                                                                                         
                                                                                                                                                                                          
  按照 skill-creator 的流程，创建测试用例并运行对比评估：                                                                                                                                 
                                                                                                                                                                                          
  步骤 1：创建测试用例                                                                                                                                                                    
                                                                                                                                                                                          
  在 skill 目录下创建 evals/evals.json：                                                                                                                                                  
                                                                                                                                                                                          
  {                                                                                                                                                                                       
    "skill_name": "video-to-summary",                                                                                                                                                     
    "evals": [                                                                                                                                                                            
      {                                                                                                                                                                                   
        "id": 1,                                                                                                                                                                          
        "prompt": "帮我总结这个B站视频: https://www.bilibili.com/video/BV1xx411c7mD",                                                                                                     
        "expected_output": "下载视频、提取音频、转录文字、生成总结",                                                                                                                      
        "assertions": []                                                                                                                                                                  
      },                                                                                                                                                                                  
      {                                                                                                                                                                                   
        "id": 2,                                                                                                                                                                          
        "prompt": "把这个YouTube视频转成文字: https://www.youtube.com/watch?v=dQw4w9WgXcQ",                                                                                               
        "expected_output": "转录文字并生成总结",                                                                                                                                          
        "assertions": []                                                                                                                                                                  
      }                                                                                                                                                                                   
    ]                                                                                                                                                                                     
  }                                                                                                                                                                                       
                                                                                                                                                                                          
  步骤 2：运行带 skill 的测试                                                                                                                                                             
                                                                                                                                                                                          
  使用 claude CLI 运行测试（skill 通过 --skill 参数指定路径）：                                                                                                                           
                                                                                                                                                                                          
  # 创建工作目录                                                                                                                                                                          
  mkdir -p /Users/chen/Project/AI_Road/Claude/skills/video-to-summary-workspace/iteration-1                                                                                               
                                                                                                                                                                                          
  # 运行测试（带 skill）                                                                                                                                                                  
  claude -p "帮我总结这个B站视频: https://www.bilibili.com/video/BV1xx411c7mD" \                                                                                                          
    --skill /Users/chen/Project/AI_Road/Claude/skills/video-to-summary \                                                                                                                  
    --output-dir /Users/chen/Project/AI_Road/Claude/skills/video-to-summary-workspace/iteration-1/eval-1                                                                                  
                                                                                                                                                                                          
  步骤 3：对比测试（无 skill baseline）                                                                                                                                                   
                                                                                                                                                                                          
  # 运行 baseline（无 skill）                                                                                                                                                             
  claude -p "帮我总结这个B站视频: https://www.bilibili.com/video/BV1xx411c7mD" \                                                                                                          
    --output-dir /Users/chen/Project/AI_Road/Claude/skills/video-to-summary-workspace/iteration-1/eval-1-baseline                                                                         
                                                                                                                                                                                          
  ---                                                                                                                                                                                     
  你想用哪种方式测试？                                                                                                                                                                    
                                                                                                                                                                                          
  如果选择方式 2 的完整测试，我可以帮你：                                                                                                                                                 
  1. 创建测试用例文件                                                                                                                                                                     
  2. 设计评估断言                                                                                                                                                                         
  3. 运行测试并生成评估报告   
```

记录DevLogs/changelog-v2.3.1.md

```bash
总结一下整个对话session中面对的问题以及做的尝试，整理到 Claude/skills/video-to-summary/DevLogs/changelog-v2.3.1.md。
核心内容：
* 问题：本Skill在本地调试OK之后，打包到~/.claude/skill/后，能击中，但是不按SKILL.md中的说明执行Python程序。
* Claude分析原因：SKILL.md不够明确
* 最终问题为解决。
* 详细记录SKILL.md尝试的几个版本
```

### V4 空文件夹重新创建

```bash
#在~/temp/test/这个空文件夹下，重新创建这个Skill
/skill-creator 创建一个skill，下载小红书视频并总结内容，步骤：
1. 用yt-dlp工具，且用固定格式的命令下载视频：yt-dlp --referer "https://www.xiaohongshu.com" --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" "视频URL"
2.用ffmpeg提取音频
3.用whisper提取文字
4.总结内容
```
