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

		# PHP static dependencies
		libbz2-dev \
		libldap2-dev \
		libssl-dev \
		libxml2-dev && \

	# Remember these packages above so we can remove them later
	apt-mark showmanual > /tmp/remove.txt && \

	apt install -y --no-install-recommends --no-install-suggests \
		# PHP dependencies
		libcurl4-openssl-dev \
		libpng-dev \
		libpq-dev \
		libreadline-dev \
		libxslt1-dev \
		libzip-dev && \

	mkdir -p /tmp/php/ && \
	cd /tmp/php && \

	# Download PHP
	curl -SLo php-${PHP_VERSION}.tar.gz http://ch1.php.net/get/php-${PHP_VERSION}.tar.gz/from/this/mirror && \

	# GPG keys from the release managers of PHP 7.3
	# Source  https://www.php.net/downloads.php#gpg-7.3
	# Source https://www.php.net/gpg-keys.php#gpg-7.3
	gpg --keyserver sks-keyservers.net --recv-keys \
		"CBAF 69F1 73A0 FEA4 B537  F470 D66C 9593 118B CCB6" \
		"F382 5282 6ACD 957E F380  D39F 2F79 56BC 5DA0 4B5D" && \

	# Verify signature
	curl -SLo php-${PHP_VERSION}.tar.gz.asc http://ch1.php.net/get/php-${PHP_VERSION}.tar.gz.asc/from/this/mirror && \
	gpg php-${PHP_VERSION}.tar.gz.asc && \

	# Unpack tarball
	tar -xvzf /tmp/php/php-${PHP_VERSION}.tar.gz && \

	# Run configuration
	cd /tmp/php/php-${PHP_VERSION} && \
	./configure \
		--enable-bcmath \
		--enable-fpm \
		--enable-mbregex \
		--enable-mbstring=all \
		--enable-opcache \
		--enable-soap \
		--enable-sockets \
		--enable-zip \
		--prefix=/usr/local/php/ \
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
	make -j$(nproc) && \

#	# Test
#	make -j$(nproc) test && \

	# Install
	make -j$(nproc) install && \
	mv /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
	mv /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf && \

	# Cleanup
	cat /tmp/remove.txt | xargs apt-mark auto && \
	apt remove -y --auto-remove --purge && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/remove.txt && \
	rm -rf /tmp/php

EXPOSE 9000

CMD ["/usr/local/php/sbin/php-fpm", "-F"]
