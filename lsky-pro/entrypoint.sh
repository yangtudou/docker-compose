#!/bin/sh
set -eu
printenv > /home/env_file.txt
# 数据库连接地址
if [ `grep -a "MYSQL_HOST" /home/env_file.txt` ];then
  x=$(cat /home/env_file.txt | grep 'MYSQL_HOST' | awk -F '=' '{print $2}')
  sed -i "81s/127.0.0.1/$x/g" /var/www/html/resources/views/install.blade.php
else
  sed -i "81s/127.0.0.1/xxx.xxx.xxx.xxx/g" /var/www/html/resources/views/install.blade.php
fi
# 数据库名字
if [ `grep -a "MYSQL_DATABASE" /home/env_file.txt` ];then
  x=$(cat /home/env_file.txt | grep 'MYSQL_DATABASE' | awk -F '=' '{print $2}')
  sed -i "89s/value=\"\"/value=\"$x\"/g" /var/www/html/resources/views/install.blade.php
else
  sed -i "89s/value=\"\"/value=\"数据库名称\"/g" /var/www/html/resources/views/install.blade.php
fi
# 数据用户名字
if [ `grep -a "MYSQL_USER" /home/env_file.txt` ];then
  x=$(cat /home/env_file.txt | grep 'MYSQL_USER' | awk -F '=' '{print $2}')
  sed -i "93s/root/$x/g" /var/www/html/resources/views/install.blade.php
else
  sed -i "93s/root/数据库用户名/g" /var/www/html/resources/views/install.blade.php
fi
# 数据库密码
if [ `grep -a "MYSQL_PASSWORD" /home/env_file.txt` ];then
  x=$(cat /home/env_file.txt | grep 'MYSQL_PASSWORD' | awk -F '=' '{print $2}')
  sed -i "97s/root/$x/g" /var/www/html/resources/views/install.blade.php
else
  sed -i "97s/root/xxxxx/g" /var/www/html/resources/views/install.blade.php
fi
#清理数据
rm /home/env_file.txt
#修改一下 apache2 的配置文件
sed -i 's/html/html\/public/g' /etc/apache2/sites-enabled/000-default.conf
exec "$@"
