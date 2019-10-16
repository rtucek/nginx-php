FROM debian:buster-slim

ENV \
	PHP_VERSION=7.3.10

RUN \
	apt update && \
	apt install -y \
		# General build dependencies
		autoconf \
		build-essential \
		ca-certificates \
		curl \
		gpg \

		# PHP build dependencies
		bison \
		pkg-config \
		re2c \

		# PHP dependencies
		libbz2-dev \
		libcurl4-openssl-dev \
		libldap2-dev \
		libpng-dev \
		libpq-dev \
		libreadline-dev \
		libssl-dev \
		libxml2-dev \
		libxslt1-dev \
		libzip-dev

RUN \
	mkdir -p /tmp/php/ && \
	cd /tmp/php && \

	# Download PHP
	curl -SLo php-${PHP_VERSION}.tar.gz http://ch1.php.net/get/php-${PHP_VERSION}.tar.gz/from/this/mirror

RUN \
	cd /tmp/php && \

	# GPG keys from the release managers of PHP 7.3
	# Source  https://www.php.net/downloads.php#gpg-7.3
	# Source https://www.php.net/gpg-keys.php#gpg-7.3
	gpg --keyserver sks-keyservers.net --recv-keys \
		"CBAF 69F1 73A0 FEA4 B537  F470 D66C 9593 118B CCB6" \
		"F382 5282 6ACD 957E F380  D39F 2F79 56BC 5DA0 4B5D" && \

	# Verify signature
	curl -SLo php-${PHP_VERSION}.tar.gz.asc http://ch1.php.net/get/php-${PHP_VERSION}.tar.gz.asc/from/this/mirror && \
	gpg php-${PHP_VERSION}.tar.gz.asc

RUN \
	# Unpack tarball
	tar -xvzf /tmp/php/php-${PHP_VERSION}.tar.gz -C /tmp/php && \

	# Run configuration
	cd /tmp/php/php-${PHP_VERSION} && \
	./configure \
		--prefix=/usr/local/php/ \
		--enable-bcmath \
		--enable-fpm \
		--enable-mbregex \
		--enable-mbstring=all \
		--enable-opcache \
		--enable-soap \
		--enable-sockets \
		--enable-zip \
		--with-bz2 \
		--with-curl \
		--with-fpm-group=www-data \
		--with-fpm-user=www-data \
		--with-gd \
		--with-gettext \
		--with-ldap \
		--with-openssl \
		--with-pcre-regex \
		--with-pdo-mysql \
		--with-pdo-pgsql \
		--with-readline \
		--with-xsl \
		--with-zlib && \

	# Compile
	make -j$(nproc)

# RUN \
#         # Test
#         cd /tmp/php/php-${PHP_VERSION} && \
#         make -j$(nproc) test

RUN \
	# Install
	cd /tmp/php/php-${PHP_VERSION} && \
	make -j$(nproc) install && \
	mv /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
	mv /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf

EXPOSE 9000

CMD ["/usr/local/php/sbin/php-fpm", "-F"]
