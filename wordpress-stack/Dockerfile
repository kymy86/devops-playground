FROM php:latest
RUN apt-get update && apt-get install -y \
    git libcurl4-gnutls-dev libxml2-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev && \
    a2enmod rewrite
RUN docker-php-ext-install curl mysqli pdo pdo_mysql curl xml gd
EXPOSE 80

RUN curl https://wordpress.org/wordpress-4.7.10.tar.gz -o wordpress-4.7.10.tar.gz
RUN tar -zvxf wordpress-4.7.10.tar.gz
RUN rm -rf wordpress-4.7.10.tar.gz
RUN rm -rf wordpress/wp-content/*
RUN rm wordpress/wp-config-sample.php
RUN cp -R wordpress/* /var/www/html
RUN rm -rf wordpress

COPY wordpress_config/* /var/www/html/
COPY . /var/www/html/wp-content

#WORKDIR /var/www/html/wp-content/plugins/

#RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#RUN php composer-setup.php
#RUN rm -rf composer-setup.php
#RUN php composer.phar install

RUN rm -rf /var/www/html/wp-content/wordpress_config