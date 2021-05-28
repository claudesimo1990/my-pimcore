FROM php:7.4-fpm

MAINTAINER Dirk Blicker <dirk.blicker@abus-kransysteme.de>

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
        curl python python-opencv libopencv-dev mariadb-client \
    && CFLAGS="-I/usr/src/php" docker-php-ext-install xmlreader \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) \
        gd \
        iconv \
        opcache \
        ldap \
        pdo \
        pdo_mysql \
        mysqli \
        intl \
        json \
        xsl \
        xmlrpc \
        simplexml \
        posix \
        mbstring \
        exif \
        bz2 \
        curl \
        dom \
        fileinfo \
        ftp \
        pcntl \
        zip \
        bcmath \
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
&& pecl install xdebug-2.9.8 \
&& mkdir /var/log/xdebug \
&& touch /var/log/xdebug/remote.log \
&& chmod 777 /var/log/xdebug/remote.log \
&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.default_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.profiler_output_dir=/var/log/xdebug" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.remote_log=/var/log/xdebug/remote.log" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.max_nesting_level=1000" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& docker-php-ext-enable xdebug \
&& apt-get autoremove -y \
    && apt-get remove -y autoconf automake libtool nasm make pkg-config libz-dev build-essential g++ \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer \
&& echo "Fertig"

COPY config/php_gitlab.ini /usr/local/etc/php/conf.d/gitlab.ini

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
&& php composer-setup.php --version=1.10.19 \
&& php -r "unlink('composer-setup.php');" \
&& mv composer.phar /usr/local/bin/composer

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs -y
RUN npm install npm -g
RUN command -v node
RUN command -v npm
