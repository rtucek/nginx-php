FROM debian:jessie

ENV \
    NGINX_VERSION=1.11.6

RUN \
    # Install tools, required for building.
    apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        libpcre3-dev \
        libssl-dev && \

    # Prepare for building.
    mkdir -p /tmp/build

RUN \
    mkdir -p /tmp/build/nginx/ && \
    cd /tmp/build/nginx && \

    # Download Nginx.
    curl -SLO https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz

RUN \
    cd /tmp/build/nginx && \
    # Unpack tarball.
    tar -xvzf nginx-${NGINX_VERSION}.tar.gz

RUN \
    # Run configuration.
    cd /tmp/build/nginx/nginx-${NGINX_VERSION} && \
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
    # Start compiling, testing and installing.
    cd /tmp/build/nginx/nginx-${NGINX_VERSION} && \
    make build && \
    make modules && \
    make install
