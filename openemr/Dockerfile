# FROM php:5.6-apache

# Use the custom php image prepared for this software:
FROM kamranazeem/php-5.6-apache-openemr



# Original download locations:
# ---------------------------
# ENV OPEN_EMR_SW_URL "https://sourceforge.net/projects/openemr/files/OpenEMR%20Current/5.0.0/openemr-5.0.0.tar.gz/download"
# ENV OPEN_EMR_PATCH_URL "https://www.open-emr.org/patch/5-0-0-Patch-8.zip"

# Files available locally from a local file server on the network (running over http, port 1080):
# ----------------------------------------------------------------------------------------------
# 192.168.0.10 fileserver

ENV OPEN_EMR_SW_URL "http://192.168.0.10:1080/openemr/openemr-5.0.0.tar.gz"
ENV OPEN_EMR_PATCH_URL "http://192.168.0.10:1080/openemr/5-0-0-Patch-8.zip"


# If you want to save download time, 
#   you can copy the (already downloaded/untar-ed) openemr software directly into  /var/www/html/
# COPY openemr-5.0.0/ /var/www/html/

# Note: We do not need phpmyadmin to be part of the installation. 
#       So we remove it from the source-code directory.
# Note: Some genius at open-emr.org decided to overwrite `setup.php` as part of the patch installation.
#       The patch technically disables it. This is so silly. 
#       The workaround is to prevent unzip from overwriting setup.php by excluding it in the unzip command.
#       It is true that anyone can run setup again, but for that, someone needs correct DB credentials in the first place!
#       They (open-emr.org) should have found a better solution instead.
# Note: Necessary OS/apache/php related software is installed in the base image.

# The following hack/fix is require on php 7.3 
# && echo "Fixing something in vendor/adodb/adodb-php/adodb-xmlschema.inc.php ..." \
# && sed -i '2199d' /var/www/html/vendor/adodb/adodb-php/adodb-xmlschema.inc.php \
# && sed -i '160d'  /var/www/html/vendor/adodb/adodb-php/adodb-xmlschema.inc.php \

# If not COPY-ing the openemr-5.0.0 directory, use these to download and extract directly from the source website.
# && curl -o openemr.tar.gz -L ${OPEN_EMR_SW_URL} \
# && tar  --no-same-owner --strip-components=1 -xzf openemr.tar.gz \
# && rm -f openemr.tar.gz \



WORKDIR /var/www/html


RUN echo "Downloading and uncompressing openemr software from: ${OPEN_EMR_SW_URL} ..." \
 && curl -# -o openemr.tar.gz -L ${OPEN_EMR_SW_URL} \
 && tar  --no-same-owner --strip-components=1 -xzf openemr.tar.gz \
 && rm -f openemr.tar.gz \
 && echo "Downloading and applying OpenEMR patch from: ${OPEN_EMR_PATCH_URL} " \
 && curl -# -LO ${OPEN_EMR_PATCH_URL}  \
 && unzip -o -q 5-0-0-Patch-8.zip -x setup.php \
 && rm -f 5-0-0-Patch-8.zip \
 && echo "Executing: chown -R www-data:www-data /var/www/html ..." \ 
 && chown -R www-data:www-data /var/www/html \
 && echo "Removing phpmyadmin as we don't want to (further) bloat this (already bloated) software .." \
 && rm -rf /var/www/html/phpmyadmin \
 && sync

# If you want to use the php.ini which comes with the official image,
#   then use the following:
# RUN mv ${PHP_INI_DIR}/php.ini-development ${PHP_INI_DIR}/php.ini

# Place in any httpd customization:
COPY openemr-httpd-customization.conf /etc/apache2/conf-enabled/

# If you want to use the php.ini recommended by openemr, then copy in the file inside ${PHP_INI_DIR}/conf.d/ :
COPY php.devpc.ini ${PHP_INI_DIR}/conf.d/

# Copy in the sqlconf.php.template file
COPY sqlconf.php.template /tmp/sqlconf.php.template

# Copy the custom entrypoint script inside the container
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["apache2-foreground"]

