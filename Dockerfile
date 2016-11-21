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
        libreadline-dev \
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

    # GPG keys from the main maintainers of Nginx
    # Source https://nginx.org/en/pgp_keys.html
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

    # Verify signature
    curl -SLO https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc && \
    gpg nginx-${NGINX_VERSION}.tar.gz.asc

RUN \
    cd /tmp/build/nginx && \
    # Unpack tarball
    tar -xvzf nginx-${NGINX_VERSION}.tar.gz

RUN \
    cd /tmp/build/nginx/nginx-${NGINX_VERSION} && \
    # Run configuration
    ./configure \
        --group=www-data \
        --user=www-data \
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

RUN \
    cd /tmp/build/php/ && \

    # GPG keys from the release managers of PHP 7.0
    # Source https://secure.php.net/gpg-keys.php#gpg-7.0
    gpg --keyserver pgp.mit.edu/ --recv "1A4E 8B72 77C4 2E53 DBA9  C7B9 BCAA 30EA 9C0D 5763" && \
    gpg --keyserver pgp.mit.edu/ --recv "6E4F 6AB3 21FD C07F 2C33  2E3A C2BF 0BC4 33CF C8B3" && \

    # Verify signature
    curl -SLo php-${PHP_VERSION}.tar.gz.asc http://ch1.php.net/get/php-${PHP_VERSION}.tar.gz.asc/from/this/mirror && \
    gpg php-${PHP_VERSION}.tar.gz.asc

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
        --enable-mbstring=all \
        --enable-opcache \
        --enable-sockets \
        --enable-zip \
        --enable-zip \
        --with-bz2 \
        --with-curl \
        --with-fpm-group=www-data \
        --with-fpm-user=www-data \
        --with-gd \
        --with-gettext \
        --with-openssl \
        --with-pcre-regex \
        --with-pdo-mysql \
        --with-pdo-pgsql \
        --with-readline \
        --with-xsl \
        --with-zlib

RUN \
    cd /tmp/build/php/php-${PHP_VERSION} && \
    # Compile, test and install
    make -j$(nproc) build && \
    make test && \
    make install

# Nginx configuration
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

RUN \
    # Fix permissions
    chown -R www-data:www-data /usr/local/nginx/html && \

    # Symlink Nginx binary
    ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/ && \

    # Copy PHP-FPM configuration files
    cp /tmp/build/php/php-${PHP_VERSION}/sapi/fpm/php-fpm.conf /usr/local/etc/php-fpm.conf && \
    cp /tmp/build/php/php-${PHP_VERSION}/sapi/fpm/www.conf /usr/local/etc/www.conf && \
    cp /tmp/build/php/php-${PHP_VERSION}/php.ini-development /usr/local/php/php.ini && \

    # Patch PHP-FPM for proper loading www.conf
    sed -Ei \
        -e 's/^;?\s*include=NONE\/etc\/php-fpm.d\/\*.conf/include=\/usr\/local\/etc\/www.conf/' \
        /usr/local/etc/php-fpm.conf && \

    # Patch www.conf config connection establishment
    sed -Ei \
        -e 's/^;?\s*listen\s*=.*/listen = \/var\/run\/php-fpm.sock/' \
        -e 's/^;?\s*?\s*listen.owner\s*=.*/listen.owner = www-data/' \
        -e 's/^;?\s*?\s*listen.group\s*=.*/listen.group = www-data/' \
        -e 's/^;?\s*?\s*listen.mode\s*=.*/listen.mode = 0660/' \
        /usr/local/etc/www.conf && \

    # Patch PHP config files on the fly
    sed -Ei \
        -e 's/^;?\s*expose_php\s*=.*/expose_php = Off/' \
        -e 's/^;?\s*cgi.fix_pathinfo\s*=.*/cgi.fix_pathinfo=0/' \
        -e 's/^;?\s*error_log\s*=.*/error_log = \/usr\/local\/nginx\/logs\/error-php.log/' \
        -e 's/^;?\s*date.timezone\s*=.*/date.timezone = \"UTC\"/' \
        -e 's/^;?\s*opcache.enable\s*=.*/opcache.enable = 1/' \
        -e 's/^;?\s*opcache.enable_cli\s*=.*/opcache.enable_cli=1/' \
        -e 's/^;?\s*opcache.memory_consumption\s*=.*/opcache.memory_consumption = 256/' \
        -e 's/^;?\s*opcache.max_accelerated_files\s=.*/opcache.max_accelerated_files = 10000/' \
        /usr/local/php/php.ini
