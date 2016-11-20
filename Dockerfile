FROM debian:jessie

ENV \
    NGINX_VERSION=1.11.6 \
    PHP_VERSION=7.0.13

RUN \
    # Install tools, required for building
    apt-get update && \
    apt-get install -y \
        # In general...
        build-essential \
        curl \

        # For Nginx
        libssl-dev \
        libpcre3-dev \

        # For PHP
        bison \
        libbz2-dev \
        libcurl4-openssl-dev \
        libpng12-dev \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
        pkg-config \
        re2c && \

    # Prepare for building
    mkdir -p /tmp/build

RUN \
    mkdir -p /tmp/build/nginx/ && \
    cd /tmp/build/nginx && \

    # Download Nginx
    curl -SLO https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz

RUN \
    cd /tmp/build/nginx && \
    # Verify signature
    curl -SLO https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc && \
    curl -SLO https://nginx.org/keys/nginx_signing.key && \
    gpg --import nginx_signing.key && \
    curl -SLO https://nginx.org/keys/aalexeev.key && \
    gpg --import aalexeev.key && \
    curl -SLO https://nginx.org/keys/is.key && \
    gpg --import is.key && \
    curl -SLO https://nginx.org/keys/mdounin.key && \
    gpg --import mdounin.key && \
    curl -SLO https://nginx.org/keys/maxim.key && \
    gpg --import maxim.key && \
    curl -SLO https://nginx.org/keys/sb.key && \
    gpg --import sb.key && \
    gpg nginx-${NGINX_VERSION}.tar.gz.asc

RUN \
    cd /tmp/build/nginx && \
    # Unpack tarball
    tar -xvzf nginx-${NGINX_VERSION}.tar.gz

RUN \
    cd /tmp/build/nginx/nginx-${NGINX_VERSION} && \
    # Run configuration
    ./configure \
        --with-file-aio \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_realip_module \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-pcre \
        --with-threads

RUN \
    cd /tmp/build/nginx/nginx-${NGINX_VERSION} && \
    # Start compiling and installing
    make -j$(nproc) build && \
    make modules && \
    make install

RUN \
    mkdir -p /tmp/build/php/ && \
    cd /tmp/build/php && \

    # Download PHP
    curl -SLo php-${PHP_VERSION}.tar.gz http://ch1.php.net/get/php-${PHP_VERSION}.tar.gz/from/this/mirror

# RUN \
    # TODO SIG VERIFICATION!!!

RUN \
    cd /tmp/build/php && \
    # Unpack tarball
    tar -xvzf php-${PHP_VERSION}.tar.gz

RUN \
    cd /tmp/build/php/php-${PHP_VERSION} && \
    # Run configuration
    ./configure \
        --enable-fpm \
        --enable-mbregex \
        --enable-mbstring \
        --enable-opcache \
        --enable-sockets \
        --enable-zip \
        --with-bz2 \
        --with-curl \
        --with-gd \
        --with-gettext \
        --with-openssl \
        --with-pcre-regex \
        --with-pdo-mysql \
        --with-pdo-pgsql \
        --with-xsl \
        --with-zlib

RUN \
    cd /tmp/build/php/php-${PHP_VERSION} && \
    # Compile, test and install.
    make -j$(nproc) build && \
    make test && \
    make install
