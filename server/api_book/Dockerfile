# 使用官方的 PHP 映像
FROM php:7.4-apache

# 設置環境變數
ARG ROOT_PASSWORD
ENV ROOT_PASSWORD=${ROOT_PASSWORD}

# 設置 root 使用者的密碼
RUN echo "root:${ROOT_PASSWORD}" | chpasswd

# 安裝 PHP MySQL 擴展和其他必要工具
RUN apt-get update -y && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    wget \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

# 啟用 Apache mod_rewrite 模組
RUN a2enmod rewrite

# 安裝 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 下載並安裝 phpMyAdmin
RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz \
    && tar xzf phpMyAdmin-latest-all-languages.tar.gz \
    && rm phpMyAdmin-latest-all-languages.tar.gz \
    && mv phpMyAdmin-*-all-languages /usr/share/phpmyadmin

COPY ./config.inc.php /usr/share/phpmyadmin/config.inc.php

    # 配置 Apache 允許所有網路訪問並使用 HTTP 認證
RUN echo '<Directory /usr/share/phpmyadmin>\n\
    Options Indexes FollowSymLinks\n\
    DirectoryIndex index.php\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/phpmyadmin.conf \
    && a2enconf phpmyadmin

# 創建符號連結以便通過 localhost/phpmyadmin 訪問
RUN ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# 設置工作目錄
WORKDIR /var/www/html/phpbb

# 下載並解壓 phpBB
RUN curl -o phpBB.zip -SL https://download.phpbb.com/pub/release/3.3/3.3.14/phpBB-3.3.14.zip \
    && unzip phpBB.zip -d /var/www/html/phpbb \
    && mv /var/www/html/phpbb/phpBB3/* /var/www/html/phpbb/ \
    && rm -rf phpBB.zip phpBB3
RUN chown -R www-data:www-data /var/www/html/phpbb

# 設置工作目錄
WORKDIR /var/www/html/api

# 安裝 Slim 框架及其依賴項
RUN composer require --with-all-dependencies slim/slim:"4.*"
RUN composer require --with-all-dependencies slim/psr7
RUN composer require --with-all-dependencies selective/basepath

# 複製 php 目錄內容到容器中
COPY ./php/ /var/www/html

# 安裝 Slim 框架及其依賴項
RUN composer require --with-all-dependencies slim/slim:"4.*"
RUN composer require --with-all-dependencies slim/psr7
RUN composer require --with-all-dependencies selective/basepath

# 配置 Apache 允許 .htaccess 文件
RUN echo '<Directory /var/www/html>\n\
    AllowOverride All\n\
</Directory>' > /etc/apache2/conf-available/allow-override.conf \
    && a2enconf allow-override

# 開放端口
EXPOSE 80

# 啟動 Apache 服務
CMD ["apache2-foreground"]

# 設置卷
VOLUME ["/var/www/html"]