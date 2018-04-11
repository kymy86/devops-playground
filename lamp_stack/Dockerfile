FROM php:7.0-apache
RUN apt-get update && apt-get install -y \
    php5-curl libcurl4-gnutls-dev libxml2-dev libpng-dev php5-gd php5-mcrypt php5-xmlrpc && \
    a2enmod rewrite
RUN docker-php-ext-install curl mysqli pdo pdo_mysql curl xml gd
EXPOSE 8080
COPY . /var/www/html/