FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    unzip \
    git
# Install PHP extensions \
RUN docker-php-ext-install pdo pdo_mysql mbstring zip xml \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

RUN pecl install xdebug-3.2.0 && docker-php-ext-enable xdebug

COPY conf.d/xdebug.ini $PHP_INI_DIR/conf.d/xdebug.ini

WORKDIR /var/www/html