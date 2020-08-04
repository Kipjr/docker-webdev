FROM php:7.2-fpm

# Set working directory
WORKDIR /var/www/

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    zip \ 
    libldb-dev \
    libldap2-dev \
    nano \
    git \
    curl

# install mensa
RUN git clone https://github.com/VSLCatena/mensa.git

WORKDIR /var/www/mensa

# Copy composer.lock and composer.json
#COPY composer.lock composer.json /var/www/
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e5325b19b381bfd88ce90a5ddb7823406b2a38cff6bb704b0acc289a09c8128d4a8ce2bbafcd1fcbdc38666422fe2806') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring ldap zip unzip

#initialize appp
RUN php composer.phar install

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory permissions
RUN chown www:www * -R

# Change current user to www
USER www #debug comment it

#ENTRYPOINT ["tail", "-f", "/dev/null"] #debug only
RUN php artisan serve --port=8080






