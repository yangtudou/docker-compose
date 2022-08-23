# nextcloud-fpm-alpine 版本官方仓库
主要用于群晖本地测试，没有开启 ssl 可以用反向代理开启。

涉及到的变量如下

- 数据库 root 密码: $MYSQL_ROOT_PASSWORD
- nextcloud 数据库密码: $MYSQL_PASSWORD
- 容器与本地互通了一个文件夹（/sj）: $path
- web 开放端口: ${web_port}


# 这样部署的 nextcloud 会遇到的问题和解决方案

- ❓ 未正确设置以解析“/.well-known/*

目前无解，不过不影响使用，如果看这个烦可以在配置文件里添加：
```
'check_for_working_wellknown_setup' => false,
```

- ❓ 此实例中的 php-imagick 模块不支持 SVG

这个我看官方仓库里全是吐槽，解决方法是进到 nextcloud 主程序的容器里，然后：

#### 这里我是怕出错替换了源
```
sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
```
```
apk add --no-cache imagemagick
```

其他问题，什么邮箱什么的，都不是什么大问题，一搜一大堆解决。

可以能回想解决一下上面遇到的问题能在部署的时候一次性解决
