---
title: app.desktop
date: 2016-06-26 11:16:15 +0800
category: Linux
tags: [linux]
---

本文章以eclipse为例

### 创建\*.desktop文件

> 创建`/usr/share/applications/eclipse.desktop`文件

```
[Desktop Entry]
Name=Eclipse
Comment=Eclipse IDE
Exec=/usr/share/eclipse/eclipse
Icon=/usr/share/eclipse/icon.xpm
Encoding=UTF-8
Terminal=false
StartupNotify=true
Type=Application
Categories=Application;Development;
```

### \*.desktop文件权限

> 确保desktop文件权限

```bash
sudo chmod u+x /usr/share/applications/eclipse.desktop
```

### 注意

`Exec`

> 是运行文件位置

`Icon`

> 是图标位置
