# traefik

> traefik 自动化反代 docker 容器

虽然 lucky 或者 Caddy 的反代服务，能自动申请续签证书已经挺方便的了。
但是依然需要两个步骤：
1. 起 docker 容器
2. 写 web 服务，Cadyy 配置文件

一旦容器的端口号发生变化，就需要同步修改其他配置文件，这件事本身就不优雅。

# docker-socket-proxy

> `/var/run/docker.sock` 需要一点保护

`/var/run/docker.sock` 本身的权限很大，几乎全权负责 docker 容器，给这个 api 增加一点限制，
比方说 traefik 只需要读取 `labels` 的权限，而不需要修改，故此处的 compose 为配合使用。
其他容器亦可参考。

不过个人认为作为内网的 homelab 使用，只要确保不会暴露在公网，这玩意没必要搞那么复杂。