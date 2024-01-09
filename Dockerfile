FROM php:8.2-alpine

RUN apk --update --no-cache add wget \
  curl \
  git \
  grep \
  build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  imagemagick-dev \
  pcre-dev \
  libtool \
  make \
  autoconf \
  g++ \
  cyrus-sasl-dev \
  libgsasl-dev \
  oniguruma-dev \
  postgresql-dev \
  supervisor

RUN docker-php-ext-install mysqli mbstring pdo pdo_mysql pdo_pgsql xml
RUN pecl channel-update pecl.php.net \
    && pecl install memcached \
    && pecl install imagick \
    && pecl install mcrypt \
    && pecl install swoole \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-enable swoole \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl

RUN echo "file_uploads = On \
memory_limit = 128M \
upload_max_filesize = 120M \
post_max_size = 120M \
max_execution_time = 1200" >> /usr/local/etc/php/conf.d/uploads.ini

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

COPY supervisord-app.conf /etc/supervisord.conf

EXPOSE 80

WORKDIR /app

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
