FROM php:7.2-fpm

# Set working directory
WORKDIR /var/www/

# Install dependencies
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    unzip \
    zip \ 
    libldb-dev \
    libldap2-dev \
    nano \
    git \
    curl

# install mensa
RUN git clone https://github.com/VSLCatena/mensa.git
ADD .env /var/www/mensa/.env
WORKDIR /var/www/mensa

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e5325b19b381bfd88ce90a5ddb7823406b2a38cff6bb704b0acc289a09c8128d4a8ce2bbafcd1fcbdc38666422fe2806') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring ldap zip

#initialize laravel dep
RUN php ./composer.phar install

# Copy existing application directory permissions
RUN chown www-data:www-data * -R

#initialize app (run=build , cmd=start)
RUN php artisan key:generate #needs .env
CMD php artisan config:cache

#issue with persistent storage
WORKDIR /var/www/

# Change current user to www | for debug comment this
#USER www-data  #does not work yet due to permission issues

#Start app // disable app exit.
CMD ["tail", "-f", "/dev/null"]