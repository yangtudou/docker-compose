FROM php:8.1-apache-buster

ENV PHP_UPLOAD_LIMIT=100M
ENV PHP_MEMORY_LIMIT=512M

# 安装 php 相关扩展
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        unzip \
        nano \
        imagemagick \
        libmagick++-dev \
    ; \
    \
    docker-php-ext-install \
        bcmath \
        pdo_mysql \
    ; \
    \
    pecl install imagick; \
    \
    docker-php-ext-enable imagick
# 配置 apache2
RUN a2enmod headers rewrite remoteip ;\
    {\
     echo RemoteIPHeader X-Real-IP ;\
     echo RemoteIPTrustedProxy 10.0.0.0/8 ;\
     echo RemoteIPTrustedProxy 172.16.0.0/12 ;\
     echo RemoteIPTrustedProxy 192.168.0.0/16 ;\
    } > /etc/apache2/conf-available/remoteip.conf;\
    a2enconf remoteip
# 配置 php 环境
RUN { \
    echo 'post_max_size = $PHP_UPLOAD_LIMIT;';\
    echo 'upload_max_filesize = $PHP_UPLOAD_LIMIT;';\
    echo 'max_execution_time = 600S;';\
    } > /usr/local/etc/php/conf.d/docker-php-upload.ini; 
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=10000'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.save_comments=1'; \
    echo 'opcache.revalidate_freq=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini; \
    \
    echo 'apc.enable_cli=1' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini; \
    \
    echo 'memory_limit=$PHP_MEMORY_LIMIT' > /usr/local/etc/php/conf.d/memory-limit.ini

VOLUME /var/www/html
# 下载文件整理
ENV LSKY_PRO_VERSION=2.1
RUN curl -fsSL -o /var/www/html/lsky-pro.zip https://github.com/lsky-org/lsky-pro/releases/download/$LSKY_PRO_VERSION/lsky-pro-$LSKY_PRO_VERSION.zip \
    && unzip /var/www/html/lsky-pro.zip \
    && rm lsky-pro.zip \
    && mkdir /var/www/data \
    && chown -R www-data:root /var/www \
    && chmod -R g=u /var/www \
    && sed -i 's/html/html\/public/g' /etc/apache2/sites-enabled/000-default.conf

CMD ["apache2-foreground"]

