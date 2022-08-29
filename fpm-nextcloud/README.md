# nextcloud-fpm-alpine 基于官方仓库

### 主要用于群晖本地调试，后期可以用反向代理开启 tls
我自己是用群晖自带的反向代理，挺好用的。（记得钩上 HSTS ）

这个仓库里还有一个用 caddy 官方的镜像做反向代理的方式，可以参考。

## 支持的变量

| 变量名 | 说明 | 备注 |
| :----: | :----: | :----: |
| `MYSQL_ROOT_PASSWORD` | 数据库 root 密码 |  |
| `nextcloud_main_path` | 映射容器 nextcloud——main 本地文件夹 | 这个路径是映射到本地的</br>如果直接映射html文件夹，cron会失效</br>至少我的群晖是这样的 |
| `web_port`| nextcloud web 映射的本地端口号 |  |
| `MYSQL_PASSWORD` | mariadb root 密码 |  |
| `PHP_UPLOAD_LIMIT` | 定义 php 上传文件大小。默认 `512M` |  |
| `NEXTCLOUD_DATA_DIR` | 更改数据文件安装位置</br>默认是 `/var/www/html/data` | 配置文件里注释掉了，要使用请打开  |
| `NEXTCLOUD_TRUSTED_DOMAINS` | 定义受信任的域名,可以是多个，用空格隔开 |  |
| `SMTP_HOST` | SMTP 服务器的主机名 |  |
| `SMTP_SECURE` | 设置为 `ssl` 以使用SSL，或设置为tls以使用STARTTLS |  |
| `SMTP_PORT` | 默认：SSL 为 `465`，不安全连接为25 SMTP 连接可选端口</br>使用 587 作为 STARTTLS 的备用端口。 |  |
| `SMTP_AUTHTYPE` | 默认：`LOGIN` 用于身份验证的方法。如果不需要身份验证，请使用 PLAIN |  |
| `SMTP_NAME` | 默认为空：smtp 身份验证的用户名 |  |
| `SMTP_PASSWORD` | 默认为空：smtp 身份验证的密码 |  |
| `MAIL_FROM_ADDRESS` | 默认情况下未设置，邮箱 @ 之前的字段 |  |
| `MAIL_DOMAIN` | 默认情况下未设置,就是发送邮箱的尾缀，如 qq.com |  |


# 这样部署的 nextcloud 可能会遇到的问题和解决方案

- ❓ 未正确设置以解析“/.well-known/*

目前无解，不过不影响使用，如果看这个烦可以在配置文件里添加：
```
'check_for_working_wellknown_setup' => false,
```

- ⚠️ 设置里网址不显示 https

往 `config.php` 配置文件里增加一行
```
'overwriteprotocol' => 'https', 
```