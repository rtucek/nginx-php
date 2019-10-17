FROM debian:buster-slim

ENV \
	NGINX_VERSION=1.16.1

RUN \
	apt update && \
	apt install -y \
		# General build dependencies
		autoconf \
		build-essential \
		ca-certificates \
		curl \
		gpg \

		# Nginx dependencies
		libghc-zlib-dev \
		libpcre3-dev \
		libssl-dev && \

	# Remember these packages above so we can remove them later
	apt-mark showmanual > /tmp/remove.txt && \

	mkdir -p /tmp/nginx/ && \
	cd /tmp/nginx && \

	# Download Nginx
	curl -SLO https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \

	# GPG keys from the main maintainers of Nginx
	# Source https://nginx.org/en/pgp_keys.html
	gpg --keyserver sks-keyservers.net --recv-keys \
		"6550 6C02 EFC2 50F1 B7A3  D694 ECF0 E90B 2C17 2083" \
		"4C2C 85E7 05DC 7308 3399  0C38 A937 6139 A524 C53E" \
		"B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8" \
		"7338 9730 69ED 3F44 3F4D  37DF A64F D5B1 7ADB 39A8" \
		"A09C D539 B8BB 8CBE 96E8  2BDF ABD4 D3B3 F580 6B4D" \
		"573B FD6B 3D8F BC64 1079  A6AB ABF5 BD82 7BD9 BF62" && \

	# Verify signature
	curl -SLO https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc && \
	gpg nginx-${NGINX_VERSION}.tar.gz.asc && \

	# Unpack tarball
	tar -xvzf /tmp/nginx/nginx-${NGINX_VERSION}.tar.gz && \

	# Compile
	cd /tmp/nginx/nginx-${NGINX_VERSION} && \
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
		--with-threads && \

	make -j$(nproc) build && \
	make -j$(nproc) install && \

	# Patch config:
	# Don't daemonize nginx by default - let it run in foreground
	echo -e "daemon off;\n$(cat /usr/local/nginx/conf/nginx.conf)" > /usr/local/nginx/conf/nginx.conf && \

	# Symlink binaries to PATH
	ln -s /usr/local/nginx/sbin/* /usr/local/sbin/ && \

	# Create log directory
	mkdir -p /var/log/nginx && \

	# Cleanup
	cd / && \
	cat /tmp/remove.txt | xargs apt-mark auto && \
	apt remove -y --auto-remove --purge && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/remove.txt && \
	rm -rf /tmp/nginx

EXPOSE 80
EXPOSE 443

CMD ["/usr/local/sbin/nginx"]
