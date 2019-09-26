FROM alpine:3.10

RUN apk --no-cache upgrade \
 && apk add --no-cache \
    apache2 apache2-ssl php7 php7-tokenizer php7-ctype php7-session php7-apache2 \
    php7-json php7-pdo php7-pdo_mysql php7-curl php7-ldap php7-openssl php7-iconv \
    php7-xml php7-xsl php7-gd php7-zip php7-soap php7-mbstring php7-zlib \
    php7-mysqli php7-sockets php7-xmlreader php7-redis php7-simplexml \
    php7-xmlwriter php7-phar php7-fileinfo \
    php7-sodium php7-calendar \
    perl mysql-client tar curl imagemagick nodejs nodejs-npm \
    python openssl py-pip openssl-dev dcron shadow \
    git build-base libffi-dev python-dev \
 && usermod -u 1000 apache \
 && ln -sf /proc/self/fd/1 /var/log/apache2/access.log \
 && ln -sf /proc/self/fd/1 /var/log/apache2/error.log \
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
 && mkdir -p /var/www/localhost/htdocs \
 && cd /var/www/localhost/htdocs/ \
 && git clone https://github.com/openemr/openemr.git --branch rel-502 --depth 1 \
 && rm -rf openemr/.git \
 && ( cd openemr \
 &&   composer install \
 &&   npm install --unsafe-perm \
 &&   npm run build \
 &&   composer global require phing/phing \
 &&   /root/.composer/vendor/bin/phing vendor-clean \
 &&   /root/.composer/vendor/bin/phing assets-clean \
 &&   composer global remove phing/phing \
 &&   composer dump-autoload -o \
 &&   composer clearcache \
 &&   npm cache clear --force \
 &&   rm -fr node_modules \
 &&   cd .. ) \
 && chmod 666 /var/www/localhost/htdocs/openemr/sites/default/sqlconf.php \
 && chown -R apache:apache /var/www/localhost/htdocs \
 && apk del --no-cache git build-base libffi-dev python-dev



WORKDIR /var/www/localhost/htdocs/openemr

COPY http-customization.conf /etc/apache2/conf.d/
COPY php.ini /etc/php7/php.ini 

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
