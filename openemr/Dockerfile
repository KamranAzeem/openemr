FROM php:5.6-apache


# Following are already part of official PHP image , so no need to re-install them:
# (use `php -m` in the base image to find the list of already installed/Compiled modules)
# -------------------------------------------------------------------------------------
# Core ctype curl date dom fileinfo filter ftp hash iconv json libxml mbstring mysqlnd 
# openssl pcre PDO pdo_sqlite Phar posix readline Reflection session SimpleXML 
# sodium SPL sqlite3 standard tokenizer xml xmlreader xmlwriter zlib  


# Following are part of openemr docker but not found in PHP's official image: 
# ---------------------------------------------------------------------------
# redis 

# What are these? and why are they needed/used in openemr docker image?
# ---------------------------------------------------------------------
# perl mysql-client tar curl imagemagick nodejs nodejs-npm \
# python openssl py-pip openssl-dev dcron shadow \
# git build-base libffi-dev python-dev \

# Useful tools to find stuff on debian:
# ------------------------------------
# apt-cache search libxml2
# apt-file find png.h 

COPY openemr-5.0.0/ /var/www/html/

# Note: docker-php-ext-install also enables the module after installation.
# Note: We do not need phpmyadmin to be part of the installation. 
# So we remove it from the source-code directory.

# && echo "Fixing something in vendor/adodb/adodb-php/adodb-xmlschema.inc.php ..." \
# && sed -i '2199d' /var/www/html/vendor/adodb/adodb-php/adodb-xmlschema.inc.php \
# && sed -i '160d'  /var/www/html/vendor/adodb/adodb-php/adodb-xmlschema.inc.php \


RUN apt-get -y update && apt-get -y install apt-utils libldap2-dev libpng-dev libxml2-dev libxslt1-dev \
    libzip-dev  libfreetype6-dev  libjpeg62-turbo-dev tar curl imagemagick mariadb-client-10.3 net-tools \
 && a2enmod headers \
 && docker-php-ext-configure ldap   --with-libdir=lib/x86_64-linux-gnu/ \
 && docker-php-ext-install calendar gd ldap mysqli pdo_mysql soap sockets xsl zip \
 && echo "Executing: chown -R www-data:www-data /var/www/html ..." \ 
 && chown -R www-data:www-data /var/www/html \
 && echo "Removing phpmyadmin as we don't want to (further) bloat this (already bloated) software .." \
 && rm -rf /var/www/html/phpmyadmin



# If you want to use the php.ini which comes with the official image,
#   then use the following:
# mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini

# If you want to use the php.ini recommended by openemr, then copy in the file:
COPY php.ini.openemr ${PHP_INI_DIR}/php.ini
