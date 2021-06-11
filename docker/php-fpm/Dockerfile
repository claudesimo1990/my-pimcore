FROM php:8.0-fpm

MAINTAINER Claude Simo <jeanclaude.simo@abus-kransysteme.de>

ARG phpini
ARG http_proxy
ARG https_proxy

ENV http_proxy="$http_proxy"
ENV https_proxy="$https_proxy"

### FOR DEVELOPMENT ONLY
ARG development
ARG proxy
RUN if [ "$proxy" -eq "1" ]; then pear config-set http_proxy $http_proxy; fi
RUN if [ "$proxy" -eq "1" ]; then echo "Acquire::http::Pipeline-Depth 0;" >> /etc/apt/apt.conf.d/99fixbadproxy; fi
RUN if [ "$proxy" -eq "1" ]; then echo 'Acquire::http::No-Cache true;' >> /etc/apt/apt.conf.d/99fixbadproxy; fi
RUN if [ "$proxy" -eq "1" ]; then echo "Acquire::BrokenProxy true;" >> /etc/apt/apt.conf.d/99fixbadproxy; fi

# Install additional software
RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf automake libtool nasm make pkg-config libz-dev build-essential openssl g++ \
        zlib1g-dev libicu-dev libbz2-dev libpng-dev libc-client-dev \
        libkrb5-dev libxml2-dev libxslt1.1 libxslt1-dev locales locales-all \
        ffmpeg html2text ghostscript libreoffice pngcrush jpegoptim exiftool poppler-utils git wget \
        libx11-dev libjpeg-dev python3-pip opencv-data webp graphviz cmake unzip cron \
        liblcms2-dev liblqr-1-0-dev libpng-dev libopenjp2-7-dev libtiff-dev libfreetype6-dev \
        libfontconfig1-dev libfftw3-dev libltdl-dev liblzma-dev libopenexr-dev \
        libwmf-dev libdjvulibre-dev libpango1.0-dev libxext-dev libxt-dev librsvg2-dev libzip-dev \
        libpng-dev libfreetype6-dev libjpeg-dev libxpm-dev libwebp-dev libldap2-dev libonig-dev libcurl4-openssl-dev libmagickwand-dev cron \
        curl python python-opencv libopencv-dev vim \
    && CFLAGS="-I/usr/src/php" docker-php-ext-install xmlreader \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure intl \

&& pecl install imagick && pecl install apcu && pecl install redis && docker-php-ext-enable redis imagick apcu \
&& wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && mv wkhtmltox/bin/wkhtmlto* /usr/bin/ \
    && rm -rf wkhtmltox \
&& git clone https://github.com/mozilla/mozjpeg.git  \
        && cd mozjpeg \
        && cmake -G"Unix Makefiles" \
        && make \
        && make install \
        && ln -s /opt/mozjpeg/bin/cjpeg /usr/bin/cjpeg \
        && cd .. \
        && rm -rf mozjpeg \
&& git clone https://github.com/google/zopfli.git \
        && cd zopfli \
        && make \
        && cp zopfli /usr/bin/zopflipng \
        && cd .. \
        && rm -rf zopfli \
&& curl -O https://www.jonof.id.au/files/kenutils/pngout-20150319-linux.tar.gz \
        && tar -xf pngout-20150319-linux.tar.gz \
        && rm pngout-20150319-linux.tar.gz \
        && cp pngout-20150319-linux/x86_64/pngout /bin/pngout \
        && cd .. \
        && rm -rf pngout-20150319-linux \
&& wget http://prdownloads.sourceforge.net/advancemame/advancecomp-1.17.tar.gz \
        && tar zxvf advancecomp-1.17.tar.gz \
        && cd advancecomp-1.17 \
        && ./configure \
        && make \
        && make install \
        && cd .. \
        && rm -rf advancecomp-1.17 \
&& wget -q https://github.com/imagemin/advpng-bin/raw/master/vendor/linux/advpng -O /usr/local/bin/advpng \
    && chmod 0755 /usr/local/bin/advpng \
&& curl -sSL https://github.com/wavexx/facedetect/raw/master/facedetect > /usr/local/bin/facedetect \
    && chmod +x /usr/local/bin/facedetect \
&& apt-get autoremove -y \
    && apt-get remove -y autoconf automake libtool nasm make pkg-config libz-dev build-essential g++ \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer \
&& echo "Fertig"

RUN docker-php-ext-install curl
RUN docker-php-ext-install dom
RUN docker-php-ext-install exif
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install gd
RUN docker-php-ext-install iconv
RUN docker-php-ext-install intl
#RUN docker-php-ext-install json
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install zip

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV PATH="${PATH}:/root/.composer/vendor/bin"

# PHP konfigurieren
COPY config/php_prod.ini /usr/local/etc/php/conf.d/abus.ini

# PHP-FPM konfigurieren
# COPY config/php-fpm.conf /usr/local/etc/php-fpm.d/z_last_abus.conf

# LDAP konfigurieren
COPY config/ldap.conf /etc/ldap/ldap.conf
RUN chmod 774 /etc/ldap/ldap.conf
COPY config/abus_ldap.cert abus_ldap.cert
RUN cat abus_ldap.cert >> /etc/ssl/certs/ca-certificates.crt
RUN rm abus_ldap.cert
RUN chmod 774 /etc/ssl/certs/ca-certificates.crt

# Add CRONJOB
RUN mkdir /var/log/cron && touch /var/log/cron/cron.log
# COPY cron/pimcore-cron /etc/cron.d/pimcore-cron
# RUN crontab /etc/cron.d/pimcore-cron

WORKDIR /var/www/html

COPY entrypoint.sh /
RUN chmod 777 /entrypoint.sh
ENTRYPOINT /entrypoint.sh
