---
title: Python、pip、Django的安装及环境配置
date: '2026-02-02 11:38:26'
permalink: >-
  /post/installation-and-environment-configuration-of-python-pip-and-django-z5sqoq.html
tags:
  - python
  - django
categories:
  - Software Development｜软件开发
layout: post
published: true
---



## 摘要

需要安装的工具：

- python（或python3）
- pip（或pip3），一般在python的默认安装包中。用于**安装**依赖
- setuptools：用于项目**打包**。

## Mac安装Python及pip

通过Homebrew安装python，一般命令会是python3、pip3，输入python可能会返回找不到命令。

```bash
# 安装Python
brew install python

# Check Version
python3 --version
pip3 --verison

# 如果pip、pip3都显示没有该命令
# 重新安装pip模组
python -m ensurepip --upgrade
# 如果pip模组没有安装，会重新安装，如果安装了，会反馈已安装的位置。
# 这之后可以用模组方式运行pip
python -m pip --version

# 想要直接运行pip指令，可安装可执行的pip文件，-U等同--upgrade
python -m pip install -U pip
```

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/se_roadimage-20260203113524-vreftp0.png)

## Windows 安装Python及pip

### 从官网下载安装包

过程中，注意选择：

- Install for all users
- 安装pip

### 配置环境变量

（Windows）设置->搜索“环境变量”，选择“编辑系统环境变量”，来改变环境变量

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20260203103117-zrfbgmt.png)

如果`pip --version`​或者`pip3 --version`返回“没有该命令”。

```bash
# 使用ensurepip修复pip，如果没有安装，会重新安装，如果安装了，会反馈已安装的位置。
python -m ensurepip --upgrade

# 通过运行模组python -m的方式，看看是否有pip模组
python -m pip --version
```

如果`python -m ensurepip --upgrade`​显示pip已经安装了，但无法直接在**Powershell**运行`pip`，

比如返回：

​`Requirement already satisfied: pip in c:\users\chenx\appdata\local\python\pythoncore-3.14-64\lib\site-packages`

但上面实际返回的是模组形态的pip，每次运行需要`python -m pip`​来运行，而能够直接在powershell运行的命令，都放在`c:\users\chenx\appdata\local\python\pythoncore-3.14-64`​下的`Scripts`目录下。

这时可以发现`c:\users\chenx\appdata\local\python\pythoncore-3.14-64\Scripts`​目录下没有`pip.exe`文件，通过运行：

```bash
python -m pip install -U pip
```

就会在`Scripts`​目录下，下载安装一个`pip.exe`文件.

## 安装Django

用pip就可以直接安装Django，同时，为了安装更快，可将pip的源替换为国内的源

```bash
#设置pip源为清华的源
pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

# pip 安装Django
pip install Django

# 检查Django是否正确安装
python3 -m django --version
```

## pip简介

pip 是 Python 的包管理工具，相当于 Node.js 中的 npm。它让你能轻松安装和管理 Python 包（也称为依赖库）。下面这个表格汇总了 pip 和 npm 的核心命令对比，帮你快速理解。

|功能描述|pip 命令|npm 命令|
| ----------| -----------------| --------------------------|
|**安装包（默认最新版）**|​`pip install <包名>`|​`npm install <包名>`|
|**根据配置文件安装所有依赖**|​`pip install -r requirements.txt`|​`npm install`|
|**初始化配置文件**|通常手动创建 `requirements.txt`|​`npm init`|
|**生成依赖清单文件**|​`pip freeze > requirements.txt`|依赖信息自动写入 `package.json`​和 `package-lock.json`|
|**卸载包**|​`pip uninstall <包名>`|​`npm uninstall <包名>`|
|**更新包**|​`pip install --upgrade <包名>`|​`npm update <包名>`|

下面我们详细看看 pip 的核心用法。

### 🔧 安装依赖

安装依赖是 pip 最核心的功能，有多种场景。

- ​**安装单个包**​：使用 `pip install <package_name>`​命令安装包，pip 会自动从 PyPI（Python 包索引）下载包及其依赖项。例如，安装 `requests`库：

  ```
  pip install requests
  ```
- ​**安装特定版本**：为确保兼容性，可以指定版本号。

  ```
  pip install requests==2.25.1
  ```
- ​**批量安装（项目管理关键）** ​：Python 项目通常使用 `requirements.txt`文件记录所有依赖及其版本。要安装文件中的所有依赖，只需运行：

  ```
  pip install -r requirements.txt
  ```

  这类似于在包含 `package.json`​的目录中运行 `npm install`。

### **配置国内镜像源**

从 PyPI 官方源下载可能较慢，可以配置国内镜像源（如清华源、阿里云源）大幅提升下载速度。

- ​**临时使用**：

  ```bash
  pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ requests
  ```
- ​**永久配置**（推荐）：执行以下命令设置全局默认源。

  ```bash
  pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple/
  ```

### 📦 管理依赖

pip 也提供命令来查看、更新和移除已安装的包。

- ​**查看已安装的包**​：使用 `pip list`​查看当前环境下所有已安装的包。使用 `pip show <package_name>`可查看某个包的详细信息。
- ​**更新包**​：使用 `pip install --upgrade <package_name>`​将包更新到最新版本。使用 `pip list --outdated`可查看所有可更新的包。
- ​**卸载包**​：使用 `pip uninstall <package_name>`卸载指定的包。

### Pip install的安装位置

**默认位置**：安装在 Python 解释器对应的 `site-packages`目录。

#### **Windows环境**

```powershell
where.exe python
# 如果输出是 D:\Program Files\Python\python.exe，那对应的目录是 D:\Program Files\Python\Lib\site-packages
# 但是由于Windows的安全策略，运行 pip install时，可能会显示“Defaulting to user installation because normal site-packages is not writeable”，表示当前用户没有权限写入系统 Python 目录，因此 pip 自动降级到用户安装模式。因此，安装在C:\Users\Administrator\AppData\Roaming\Python\下。
pip show [package_name] # 查看安装位置
```

#### Mac环境

```bash
pip list #可能需要pip3 list
pip show [package_name] # 查看安装位置
# 查看python的安装位置
whereis python ##可能 whereis python3
```

#### (推荐）基于项目的虚拟环境

- 使用 `venv`​: `./venv/lib/pythonX.X/site-packages/`
- 使用 `virtualenv`​: `./env/lib/pythonX.X/site-packages/`

### 🚀 虚拟环境venv

​**使用虚拟环境**​：**强烈建议**为每个项目创建独立的虚拟环境（如使用 `venv`模块），这样可以隔离项目依赖，避免冲突。基本流程如下：

```bash
# 创建虚拟环境
python -m venv myenv
# 激活虚拟环境 (Windows)
myenv\Scripts\activate
# 激活后，在此环境下用pip安装的所有包都是独立的
pip install requests
```

注意：每次打开终端都要激活虚拟环境

#### ​`python -m venv`​和`virtualenv`

> 最新趋势：随着 Python 2 淘汰，大多数现代项目转向使用 `python -m venv`​ 作为标准做法。但理解 `virtualenv` 对维护旧项目仍然重要。

|特性|​`python -m venv`|​`virtualenv`|
| ------| -------------------------| ----------------------------|
|**来源**|Python 3.3+ 内置模块|第三方包|
|**安装需求**|无需安装（Python 自带）|需要单独安装 (`pip install virtualenv`)|
|**Python版本兼容**|Python 3.3+|支持 Python 2.7 和 3.x|
|**执行方式**|​`python -m venv myenv`|​`virtualenv myenv`|
|**创建速度**|较快|较慢|
|**包含工具**|默认不带 pip/setuptools|默认包含 pip 和 setuptools|
|**配置灵活性**|基础功能|更多高级选项|
|**激活脚本**|相同|相同|

**激活环境**

```bash
# 使用 venv
python -m venv myenv        # 创建
source myenv/bin/activate  # 激活 (Unix)
myenv\Scripts\activate     # 激活 (Windows)

# 使用 virtualenv
pip install virtualenv 	   # 需要先安装第三方库
virtualenv myenv           # 创建
source myenv/bin/activate  # 激活 (相同方式)
```

**使用场景建议**：

推荐 `venv` 当：

- 使用 Python 3.3+
- 需要标准、轻量的解决方案
- 开发环境不需要 Py2 兼容

推荐 `virtualenv` 当：

- 需要支持 Python 2.7
- 需要更多配置选项
- 希望默认包含 pip/setuptools
- 在旧项目或需要兼容多种环境时

​`virtualenv` 提供更多配置选项：

```bash
# 指定Python解释器
virtualenv -p python3.10 myenv

# 不使用系统包
virtualenv --no-site-packages myenv

# 快速创建
virtualenv --no-download myenv
```

### 💎 核心要点

简单来说，记住这几点就掌握了 pip 的精髓：

- ​**安装包**​：`pip install <包名>`
- ​**管理项目依赖**​：使用 `requirements.txt`​文件，并通过 `pip install -r requirements.txt`安装。
- ​**最佳实践**​：​**始终在虚拟环境中安装项目依赖**​，并使用 `pip freeze > requirements.txt`记录准确的依赖版本。

希望这些介绍能帮助你快速上手 pip。如果你对某个特定命令或场景想了解更多细节，随时可以告诉我。

## setuptools简介

是的，你的理解非常准确。在现代 Python 项目中，​**setuptools 的核心定位已经聚焦于“打包”** ​，即将你的代码、资源文件及其元数据（如名称、版本、依赖项）规范地打包成可用于分发的格式（如源代码包 `.tar.gz`​和更现代的二进制包 `.whl`），以便通过 pip 进行安装。

下面这个表格能帮你快速了解 setuptools 在现代 Python 项目中的主要职责，以及它和 pip 如何分工协作。

|工具|核心职责|简单比喻|
| ------| --------------------------------------------------------------------------------------| -----------------------------------------------------------------------|
|​**​`setuptools`​**|​ **“打包”** ：定义项目元信息、声明依赖、包含资源文件、构建可分发的包文件。|​**产品经理和包装工**：负责设计产品规格（元数据）并把零件（代码、数据）打包进盒子。|
|​**​`pip`​**|​ **“安装”** ：从 PyPI 或本地路径获取包文件，解包并安装到当前 Python 环境，同时解决依赖关系。|​**配送和装配工**：负责接收盒子，把它运到用户家（Python 环境），拆开包装并组装好。|

### 🛠️ 核心打包功能

setuptools 通过一个配置文件（通常是 `setup.py`​或更现代的 `pyproject.toml`）来定义项目的方方面面：

- ​**项目元数据**：在配置文件中定义项目的基本信息，如名称、版本、作者、描述等。
- ​**依赖管理**​：通过 `install_requires`参数声明项目运行所必须依赖的第三方库，当用户用 pip 安装你的包时，这些依赖会被自动安装。
- ​**包含非代码文件**：可以配置包含项目中的非代码文件，如配置文件、静态资源、数据文件等。
- ​**生成命令行工具**​：通过 `entry_points`配置，可以将项目中的特定函数注册为命令行命令，安装后用户可以直接在终端使用。

### 📦 现代打包流程

在实际操作中，使用 setuptools 打包一个项目并发布到 PyPI（Python Package Index）的典型流程如下：

1. ​**项目组织**​：将你的代码按包（含 `__init__.py`的目录）组织好。
2. ​**编写配置文件**​：在项目根目录创建 `setup.py`​或 `pyproject.toml`文件。
3. ​**构建分发包**​：在项目根目录运行命令（如 `python setup.py sdist bdist_wheel`​或使用 `build`​工具）来生成分发文件。这会生成一个 `dist`​目录，里面包含源码包（`.tar.gz`​）和二进制包（`.whl`）。
4. ​**上传到 PyPI**​：使用 `twine`​工具将 `dist`​目录下的包文件上传到 PyPI，这样其他人就可以通过 `pip install your-package-name`来安装你的项目了。

### 💡 重要提示

- ​**优先使用** **​`pyproject.toml`​**​：这是由 PEP 518 引入的现代配置文件标准，正逐渐取代 `setup.py`​。它更清晰、更静态，且被 Poetry、Flit 等新一代工具原生支持。即使使用 setuptools 作为后端，也推荐使用 `pyproject.toml`来声明构建系统要求。
- ​**避免使用** **​`easy_install`​**​：setuptools 曾经带有一个叫做 `easy_install`​的安装工具，但它现在​**已被弃用**​。​**请始终使用** **​`pip`​**​**来安装 Python 包**，因为 pip 能更好地处理依赖关系。

希望这些信息能帮助你更清晰地理解 setuptools 的角色！如果你对如何编写 `setup.py`​或 `pyproject.toml`的具体细节感兴趣，我可以提供更深入的介绍。

## 实战经验

‍
