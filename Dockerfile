FROM php:7.2-fpm
ARG APP_NAME
ARG APP_REPO
ARG APP_REPO_BRANCH

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
RUN git clone $APP_REPO
WORKDIR /var/www/$APP_NAME
RUN git checkout $APP_REPO_BRANCH

RUN bash -c "if [[ ! -f /var/www/$APP_NAME/.env ]]; then cp /var/www/$APP_NAME/.env.example /var/www/$APP_NAME/.env; fi"

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring ldap zip

#initialize laravel dep
RUN php ./composer.phar update
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
