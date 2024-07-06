# Base Image
FROM debian:buster

# Update package list
RUN apt-get update
# Install dependencies
RUN apt-get -y install \
    # Basic utilities for downloading files
    wget \
    curl \
    bash \
    # Php and various modules for MySQL, CGI, GD graphic lib, CLI tools
    # and multibyte string handling
    php \
    php-cgi \
    php-mysql \
    php-fpm \
    php-pdo \
    php-gd \
    php-cli \
    php-mbstring \
    # Redis key-value store and its PHP extension for Redis support
    redis \
    php-redis \
    # Cleans up package cache to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Downloads the WP-CLI, makes it executable and makes it global
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copies custom PHP-FPM pool configuration into the container
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/
# Creates a directory for PHP-FPM to store its socket file
# Which allows nginx to communicate with PHP-FPM
RUN mkdir /run/php

# Copies a wordpress setup shell script into the container
COPY ./tools/create_wordpress.sh /usr/local/bin/
# Makes the script executable
RUN chmod +x /usr/local/bin/create_wordpress.sh
# Specifies entry point command for the container
ENTRYPOINT [ "/usr/local/bin/create_wordpress.sh" ]

# Directory where nginx will serve its files from
WORKDIR /var/www/html/

# Exposes port 9000 from the container to allow communication with PHP-FPM
EXPOSE 9000

# Command to start PHP-FPM in foreground mode (-F)
# PHP-FPM will listen for requests on port 9000
# and handle PHP scripts as instruted by Nginx
CMD [ "/usr/sbin/php-fpm7.3", "-F" ]
