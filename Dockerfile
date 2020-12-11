FROM php:7.2-fpm

# Set working directory
CMD mkdir /var/www/ -p
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

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring ldap zip

#issue with persistent storage
WORKDIR /var/www/
# Change current user to www | for debug comment this
#USER www-data  #does not work yet due to permission issues

#Start app // disable app exit.
CMD ["tail", "-f", "/dev/null"]
