---
title: 当我用Docker安装了另一个知识库程序，需要在知识库的设置里填写ollama的访问URL，我应该填哪一个？
date: '2025-07-10 22:02:36'
permalink: >-
  /post/when-i-install-another-knowledge-base-program-with-docker-i-need-to-fill-in-the-access-url-of-the-ollama-in-the-knowledge-base-settings-which-one-should-i-fill-in-zrydx0.html
tags:
  - docker
  - ollama
categories:
  - Software Development｜软件开发
layout: post
published: true
---





# 摘要

- 分为4种情况

  - ollama（容器），知识库（宿主）：http://localhost:11434
  - ollama（宿主），知识库（容器）：http://host.docker.internal:11434
  - ollama（容器），知识库（容器）

    - 方案一：

      - 获取ollama的Docker容器地址：`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ollama`​
      - 假设得到的IP是172.17.0.2，那么在知识库程序中应配置：http://172.17.0.2:11434
      - 缺点：容器重启后IP可能变化，不推荐。
    - 方案二：

      - 如果已经跑起来了ollama和知识库，需要先`docker stop`​和`docker rm`​
      - 创建自定义网络（如果还没创建）：  
        ​`docker network create my-network`​
      - 启动Ollama容器时加入该网络：  
        ​`docker run -d --name ollama --network my-network -p 11434:11434 ollama/ollama`​
      - 启动知识库容器时也加入同一网络：  
        ​`docker run -d --name knowledge-base --network my-network -p 3000:3000 your-knowledge-base-image`​
      - 在知识库程序的设置中，Ollama的URL配置为：`http://ollama:11434`​  
        注意：这里使用容器名称（ollama）作为主机名，因为Docker的自定义网络内置了DNS解析，可以通过容器名称解析。

# 详细记录

> 我们正在解决的是：在一个Docker化的知识库程序中配置Ollama服务的访问地址。
>
> 背景：
>
> - Ollama服务运行在一个Docker容器中（假设容器名为ollama），暴露端口11434给宿主机和其他容器。
> - 知识库程序也运行在Docker容器中（假设容器名为knowledge-base），需要配置Ollama的URL。
>
> 关键点：两个容器在Docker网络中的相互访问方式。
>
> 根据两个容器是否在同一个Docker网络中，配置方式不同：
>
> ## 情况一：两个容器使用默认网络（即没有创建自定义网络，都在默认的bridge网络）
>
> - 默认情况下，容器之间通过IP地址访问。
> - 先获取Ollama容器的IP地址：  
>   ​`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ollama`​
> - 假设得到的IP是172.17.0.2，那么在知识库程序中应配置：http://172.17.0.2:11434
> - 缺点：容器重启后IP可能变化，不推荐。
>
> ## 情况二：将两个容器连接到同一个自定义网络（推荐）
>
> 步骤：
>
> 1. 创建自定义网络（如果还没创建）：  
>     docker network create my-network
> 2. 启动Ollama容器时加入该网络：  
>     docker run -d --name ollama --network my-network -p 11434:11434 ollama/ollama
> 3. 启动知识库容器时也加入同一网络：  
>     docker run -d --name knowledge-base --network my-network -p 3000:3000 your-knowledge-base-image
> 4. 在知识库程序的设置中，Ollama的URL配置为：http://ollama:11434  
>     注意：这里使用容器名称（ollama）作为主机名，因为Docker的自定义网络内置了DNS解析，可以通过容器名称解析。
>
> ## 情况三：知识库程序在宿主机运行（非Docker），而Ollama在Docker容器中
>
> - 配置：http://localhost:11434  
>   因为Ollama容器将端口映射到了宿主机的11434端口。
>
> ## 情况四：知识库程序在Docker容器中，但Ollama在宿主机上运行（而不是容器内）
>
> - 这种情况较少见（因为Ollama也是Docker安装的），但假设有：在宿主机运行了Ollama（比如直接安装的Ollama，监听11434）。
> - 那么，在知识库容器中配置时，使用Docker提供的特殊DNS名称：host.docker.internal  
>   配置：http://host.docker.internal:11434  
>   注意：host.docker.internal 是Docker为容器提供的一个指向宿主机（在Windows/macOS上有效，Linux需要特殊处理）的特殊域名。
>
> 我们的场景：
>
> - 根据之前对话，Ollama是通过Docker安装并运行在容器中的。
> - 知识库程序也是Docker容器。
>
> 因此，最推荐的是情况二：使用自定义网络，通过容器名称访问。
>
> 操作步骤：
>
> 1. 停止并删除现有容器（如果有）：  
>     docker stop ollama  
>     docker rm ollama
>
>     ### 同样处理知识库容器（如果已经创建）
> 2. 创建自定义网络（如果尚未创建）：  
>     docker network create my-net
> 3. 启动Ollama容器并加入自定义网络：  
>     docker run -d --name ollama --network my-net -p 11434:11434 ollama/ollama
> 4. 启动知识库容器并加入同一网络：  
>     docker run -d --name knowledge-base --network my-net -p 3000:3000 knowledge-base-image
> 5. 在知识库程序的配置界面中，设置Ollama的URL为：http://ollama:11434
>
> 验证：
>
> - 进入知识库容器的shell：  
>   docker exec -it knowledge-base /bin/sh
> - 在容器内部尝试访问Ollama：  
>   curl http://ollama:11434  
>   应该能返回Ollama的响应。
>
> 注意：如果知识库程序运行在非容器环境（如直接运行在Windows宿主机上），那么它应该通过localhost:11434访问Ollama。
>
> 总结：
>
> - 如果知识库程序是Docker容器，且和Ollama在同一个自定义网络中：http://ollama:11434
> - 如果知识库程序运行在宿主机上：http://localhost:11434
>
> 请根据实际情况选择配置。

要正确配置知识库程序访问 Ollama 服务，访问地址的选择取决于您的容器部署方式和网络架构。以下是详细指南：

### ⚙️ 根据部署场景选择正确的访问 URL

|部署场景|推荐访问 URL|说明|
| ----------| --------------| --------------------------------------------|
|**Ollama 和知识库在同一主机，且知识库是 Docker 容器**|​`http://ollama:11434`​|最佳实践，使用容器名访问（需要自定义网络）|
|**Ollama 和知识库在同一主机，知识库运行在宿主机（非容器）**|​`http://localhost:11434`​|标准主机访问方式|
|**Ollama 单独容器，知识库运行在宿主机**|​`http://localhost:11434`​|宿主机通过端口映射访问|
|**知识库容器使用默认网桥网络**|​`http://<ollama容器IP>:11434`​|临时方案（需获取容器动态IP）|
|**跨主机访问**|​`http://<主机公网IP或域名>:11434`​|生产环境需安全配置（防火墙、HTTPS等）|

---

### 🧩 最推荐方案：使用自定义 Docker 网络（容器间直接通信）

#### 步骤 1：创建专用网络

```
docker network create knowledge-net
```

#### 步骤 2：启动 Ollama 容器（加入网络）

```
docker run -d \
  --name ollama \
  --network knowledge-net \
  -v ollama_data:/root/.ollama \
  ollama/ollama
```

#### 步骤 3：启动知识库容器（加入同一网络）

```
docker run -d \
  --name knowledge-base \
  --network knowledge-net \
  -p 8080:8080 \
  your-knowledge-image
```

#### 步骤 4：在知识库程序中配置 Ollama URL

```
http://ollama:11434
```

#### ✅ 优势：

1. 使用容器名（`ollama`​）替代 IP，自动 DNS 解析
2. 网络隔离更安全
3. 容器重启后地址不变
4. 无需暴露端口到宿主机（除非需要外部访问）

---

### 🔍 验证连接（容器内测试）

```
# 进入知识库容器
docker exec -it knowledge-base sh

# 测试 Ollama 连接
curl http://ollama:11434
```

预期返回：

```
{"status":"Ollama is running"}
```

---

### ⚠️ 常见问题排查

1. **连接拒绝/超时**

    - 确认 Ollama 正常运行：`docker logs ollama`​
    - 检查网络连通性（在知识库容器执行）：

      ```
      ping ollama
      nslookup ollama
      ```
2. **容器无法解析名称**  
    确保使用自定义网络（非默认网桥）：

    ```
    docker inspect knowledge-base -f '{{json .NetworkSettings.Networks}}'
    ```
3. **防火墙限制（跨主机时）**   
    在主机的防火墙打开 11434 端口

---

### 📝 配置示例（不同知识库系统）

1. **LangChain/LLMStack 类系统**  
    API Endpoint：`http://ollama:11434/api/generate`​  
    Chat Endpoint：`http://ollama:11434/api/chat`​
2. **本地知识库（如 LocalGPT）**

    ```
    # config.yml
    llm:
      api_url: "http://ollama:11434/v1"
      model: "llama3"
    ```
3. **Web UI 系统（如 Open WebUI）**

    ```
    # .env 配置文件
    OLLAMA_API_BASE_URL=http://ollama:11434
    ```

---

> 💡 **专业建议**：在任何 Docker 部署中，优先使用**自定义网络+容器名称**的访问方式，这符合 Docker 的最佳实践，能避免 90% 以上的连接问题。只有在需要从外部主机访问时才考虑公网 IP 或端口转发。
