# 群晖用 caddy 反向代理 nextcloud

内网，利用 dns 的方式自动生成证书，开启 https 

**需要**
- ddns 绑定到域名，可以使用群晖自带
- caddy 配置文件要写好 主要是 dnspodcn 模块要添加。

Caddyfile 配置文件参考：
```
(dnspodcn) {
    tls {
        dns dnspodcn $id $token
    }
}
$domains:$port {
    file_server
    header Strict-Transport-Security max-age=31536000;
    reverse_proxy $loaclhost:$port
    import dnspodcn
}
```
 
## 目前支持的变量

| **变量名** | **说明** |
| :----: | :----: |
| mariadb 部分 |
| `MYSQL_ROOT_PASSWORD` | 数据库 root 密码 |
| `nextcloud_main_path` | 映射容器 nextcloud—main 目录 |
| nextcloud 部分 |
| `NEXTCLOUD_MYSQL_PASSWORD` | mariadb nextcloud 密码 |
| `PHP_UPLOAD_LIMIT` | 定义 php 上传文件大小</br>默认 `512M` |
| `NEXTCLOUD_DATA_DIR` | 更改数据文件安装位置</br>默认是 `/var/www/html/data` |
| `NEXTCLOUD_TRUSTED_DOMAINS` | 定义受信任的域名,可以是多个，用空格隔开 |
| `SMTP_HOST` | SMTP 服务器的主机名 |
| `SMTP_SECURE` | 设置为 `ssl` 以使用SSL，或设置为tls以使用STARTTLS |
| `SMTP_PORT` | 默认：SSL 为 `465`</br>不安全连接为25 SMTP 连接可选端口</br>使用 587 作为 STARTTLS 的备用端口。 |
| `SMTP_AUTHTYPE` | 默认 `LOGIN` 用于身份验证的方法</br>如果不需要身份验证，请使用 PLAIN |
| `SMTP_NAME` | 默认为空</br>smtp 身份验证的用户名 |
| `SMTP_PASSWORD` | 默认为空</br>smtp 身份验证的密码 |
| `MAIL_FROM_ADDRESS` | 默认情况下未设置</br>邮箱 @ 之前的字段 |
| `MAIL_DOMAIN` | 默认情况下未设置</br>就是发送邮箱的尾缀</br>如 qq.com |
| nginx 部分 |
| `loacl_port`| nextcloud web 映射的本地端口号</br>这里也要在Caddyfile文件部分一样 |
| caddy 部分 |
| `proxy_https_port` | caddy 定义 https 端口，如果 443 被禁用 |
| `proxy_http_port` | caddy 定义 http 端口，如果 80 被禁用 |
| `loacl_certs` | 映射本地证书目录 |
| `caddy_caddyfile` | 映射本地 Caddyfile 目录 |
| `caddy_data` | 映射 caddy_data 目录 |
| `caddy_config` | 映射  caddy_config 目录 |


# Q&A

- ⚠️ 反向代理头部未设置正确

往 `config.php` 配置文件里增加一行，这里的 `192.168.1.1` 取决于你的网关
```
'trusted_proxies'   => ['192.168.1.1'],
```

- ⚠️ 设置里网址不显示 https

往 `config.php` 配置文件里增加一行
```
'overwriteprotocol' => 'https', 
```