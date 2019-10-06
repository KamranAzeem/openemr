FROM php:5.6-apache


# Following php modules are already part of official PHP image , so no need to re-install them:
# (use `php -m` in the base image to find the list of already installed/Compiled modules)
# -------------------------------------------------------------------------------------
# * Core ctype curl date dom fileinfo filter ftp hash iconv json libxml mbstring mysqlnd 
# * openssl pcre PDO pdo_sqlite Phar posix readline Reflection session SimpleXML 
# * sodium SPL sqlite3 standard tokenizer xml xmlreader xmlwriter zlib  


# Following are part of openemr docker but not found in PHP's official image: 
# ---------------------------------------------------------------------------
# redis 

# What are these OS packages? and why are they needed/used in openemr docker image?
# ----------------------------------------------------------------------------------
# perl mysql-client tar curl imagemagick nodejs nodejs-npm \
# python openssl py-pip openssl-dev dcron shadow \
# git build-base libffi-dev python-dev \

# Useful tools to find stuff on debian:
# ------------------------------------
# apt-cache search libxml2
# apt-file find png.h 


ENV OPEN_EMR_SW_URL "https://sourceforge.net/projects/openemr/files/OpenEMR%20Current/5.0.0/openemr-5.0.0.tar.gz/download"
ENV OPEN_EMR_PATCH_URL "https://www.open-emr.org/patch/5-0-0-Patch-8.zip"

WORKDIR /var/www/html

COPY openemr-5.0.0/ /var/www/html/

# Note: docker-php-ext-install also enables the module after installation.
# Note: We do not need phpmyadmin to be part of the installation. 
# So we remove it from the source-code directory.

# The following hack/fix is require on php7.3 
# && echo "Fixing something in vendor/adodb/adodb-php/adodb-xmlschema.inc.php ..." \
# && sed -i '2199d' /var/www/html/vendor/adodb/adodb-php/adodb-xmlschema.inc.php \
# && sed -i '160d'  /var/www/html/vendor/adodb/adodb-php/adodb-xmlschema.inc.php \

# If not COPY-ing the openemr-5.0.0 directory, use these to download and extract directly from the source website.
# && curl -o openemr.tar.gz -L ${OPEN_EMR_SW_URL}
# && tar  --no-same-owner --strip-components=1 -xzf openemr.tar.gz \
# && rm -f openemr.tar.gz

RUN apt-get -y update && apt-get -y install apt-utils libldap2-dev libpng-dev libxml2-dev libxslt1-dev \
    libzip-dev  libfreetype6-dev  libjpeg62-turbo-dev tar curl imagemagick mariadb-client net-tools unzip \
 && a2enmod headers \
 && docker-php-ext-configure ldap   --with-libdir=lib/x86_64-linux-gnu/ \
 && docker-php-ext-install calendar gd ldap mysqli pdo_mysql soap sockets xsl zip \
 && curl -LO ${OPEN_EMR_PATCH_URL}  \
 && sync

RUN unzip -o -q 5-0-0-Patch-8.zip \
 && rm -f 5-0-0-Patch-8.zip
 
RUN echo "Executing: chown -R www-data:www-data /var/www/html ..." \ 
 && chown -R www-data:www-data /var/www/html \
 && echo "Removing phpmyadmin as we don't want to (further) bloat this (already bloated) software .." \
 && rm -rf /var/www/html/phpmyadmin

# If you want to use the php.ini which comes with the official image,
#   then use the following:
# mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini

# If you want to use the php.ini recommended by openemr, then copy in the file:
COPY php.ini.openemr ${PHP_INI_DIR}/php.ini

COPY sqlconf.php.template /tmp/sqlconf.php.template

# Copy the custom entrypoint script inside the container
COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

