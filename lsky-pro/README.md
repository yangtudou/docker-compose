# 通过docker 部署 [lsky-pro（兰空图床）](https://www.lsky.pro) 

### 特色
**镜像添加了environment 环境变量参数，可以在部署前就设置好。目前支持的变量是：**

| 变量名 | 说明 |
| :---: | :---: |
| MYSQL_ROOT_PASSWORD | MySQL root 密码 |
| MYSQL_DATABASE | MySQL 自动创建的数据库名 |
| MYSQL_USER | MySQL 自动创建的用户名 |
| LSKY_PRO_MYSQL_PASSWORD | MySQL 自动创建的用户的密码 |
| MYSQL_HOST | MySQL 数据库地址 |
| local_port | 映射本地端口号 |

使用方法：
```
docker run -it --name lsky-pro \
-v $path:/var/www/html \
-p $local_port:80 \
-e MYSQL_HOST=db \
-e MYSQL_DATABASE=lsky_pro \
-e MYSQL_USER=lsky_pro \
-e MYSQL_PASSWORD=$LSKY_PRO_MYSQL_PASSWORD \
yangtudou/lsky-pro
```
docker-compose
```
version: '3'

services:
  db:
    image: mysql
    command: --default-authentication-plugin=mysql_native_password
    container_name: lsky-pro-mysql
    restart: always
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
      - MYSQL_DATABASE=lsky_pro
      - MYSQL_USER=lsky_pro
      - MYSQL_PASSWORD=$LSKY_PRO_MYSQL_PASSWORD

  app:
    image: yangtudou/lsky-pro
    container_name: lsky-pro
    restart: always
    ports:
      - ${local_port}:80
    volumes:
      - lsky-pro:/var/www/html
    environment:
      - MYSQL_HOST=db
      - MYSQL_DATABASE=lsky_pro
      - MYSQL_USER=lsky_pro
      - MYSQL_PASSWORD=$LSKY_PRO_MYSQL_PASSWORD
    depends_on:
      - db

volumes:
  db:
  lsky-pro:
  
networks:
  lsky-pro:
```
docker-compose up -d


个人 docker 仓库地址 [↗️](https://hub.docker.com/r/yangtudou/lsky-pro)

感谢作者
[wisp-x](https://github.com/wisp-x)

