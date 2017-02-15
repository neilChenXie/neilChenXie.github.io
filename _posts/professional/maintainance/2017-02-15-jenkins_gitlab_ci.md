---
title: Jenkins搭建Gitlab持续集成
date: 2017-02-15 16:30:15 +0800
category: maintainance
tags: [jenkins, gitlab, linux]
---

公司内部博客通过Jekyll编写，并存储在内部gitlab服务器上。通过持续集成，可以实现博客的实时更新。

但是gitlab-ci项目首次安装遇到奇怪Bug，在公司搬迁后，又出现了通信问题；加上其难以Debug，决定使用替代方案Jenkins。

### 1 Jenkins Install

> CentOS 7

#### 1.1 Repo file

> add repo file under `/etc/yum.repos.d/`

```
[jenkins]
name=Jenkins
baseurl=http://pkg.jenkins.io/redhat
gpgcheck=0
```

#### 1.2 Install

```bash
yum update
yum install jenkins
```

* [Reference](https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Red+Hat+distributions)

### 2 Jenkins Config

find jenkins config file `rpm -ql jenkins`, normally, you can see `/etc/sysconfig/jenkins`

edit `/etc/sysconfig/jenkins` file. e.g. `JENKINS_PORT` for which port jenkins is listening.

### 3 Startup

```
service jenkins start/stop/restart
```

#### 3.1 Explain

`service` run **System V init scripts**, which are under `/etc/init.d/`.

We can also use `systemctl`

[difference between **service** and **systemctl**](http://unix.stackexchange.com/questions/170068/service-vs-systemctl-scripts-which-to-use)

### 4 Setup Process

#### 4.1 Admin

1. Create `new item` with name **Blog-{name}**
2. Send `GitLab CI Service URL` and `Secret Token` under Build Triggers to **User**
3. generate `ssh key pair` & send `public key` to **User**.

```
ssh-keygen -t rsa -f ~/Documents/sshkey/{name}
```

#### 4.2 User

1. Fork **Blog Template**
2. Add `ssh public key` to **account**
3. Add `webhook` under `Integration` of **this project**;
4. Generate `Gitlab Access Token`; send `project git url` & `Access Token` to **Admin**

#### 4.3 Admin

1. Create `Configure System`->`Gitlab Connection` using **User** `Access Token` with name **Gitlab-API-Token-{username}**
2. Complete `new item` configuration using `ssh private key` with name **sshKey-{username}**.

### 5 Reference

[Jenkins Gitlab-plugin doc](https://github.com/jenkinsci/gitlab-plugin/wiki/Setup-Example)
