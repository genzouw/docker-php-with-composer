FROM php:7.2.4-cli
MAINTAINER genzouw <genzouw@gmail.com>

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get -y install git unzip zlib1g-dev libpq-dev libicu-dev && \
  apt-get clean && \
  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN docker-php-ext-install pdo pdo_pgsql pgsql mbstring intl

COPY config/php.ini /usr/local/etc/php/

RUN BIN_DIR="/usr/local/bin"; \
  [ ! -d "$BIN_DIR" ] && mkdir -p "$BIN_DIR"; cd $BIN_DIR \
  if [[ ! -f "${BIN_DIR}/composer.phar" ]]; then \
    php -r "readfile('https://getcomposer.org/installer');" | php; \
    chmod u+x $BIN_DIR/composer.phar; \
    ln -s composer.phar composer; \
  fi

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN composer global require "hirak/prestissimo:*"
