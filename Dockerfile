FROM php:7.1.17-cli

LABEL maintainer "genzouw <genzouw@gmail.com>"

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get -y install \
    --no-install-recommends \
    git \
    unzip \
    zlib1g-dev \
    libpq-dev \
    libicu-dev \
    procps \
    libxslt-dev \
    unixodbc-dev \
    locales \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*


RUN docker-php-source extract \
    && cd /usr/src/php/ext/odbc \
    && phpize \
    && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
    && ./configure --with-unixODBC=shared,/usr \
    && cd /root \
    && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
    && docker-php-ext-install pdo pdo_pgsql pdo_mysql pgsql mbstring intl xsl pdo_odbc odbc \
    && docker-php-source delete \
  ;


COPY config/php.ini /usr/local/etc/php/

RUN locale-gen ja_JP.UTF-8 && \
  localedef -f UTF-8 -i ja_JP ja_JP.utf8

RUN echo 'export LANG=ja_JP.UTF-8' >> /etc/bash.bashrc

RUN BIN_DIR="/usr/local/bin"; \
  [ ! -d "$BIN_DIR" ] && mkdir -p "$BIN_DIR"; cd $BIN_DIR \
  if [[ ! -f "${BIN_DIR}/composer.phar" ]]; then \
    php -r "readfile('https://getcomposer.org/installer');" | php; \
    chmod u+x $BIN_DIR/composer.phar; \
    ln -s composer.phar composer; \
  fi

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN composer global require "hirak/prestissimo:*"
