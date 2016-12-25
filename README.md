[![](https://images.microbadger.com/badges/image/janus1990/docker-nginx-php.svg)](https://microbadger.com/images/janus1990/docker-nginx-php "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/janus1990/docker-nginx-php.svg)](https://microbadger.com/images/janus1990/docker-nginx-php "Get your own version badge on microbadger.com")

## nginx-php Dockerfile

This repository contains source code of [janus1990/docker-nginx-php](https://hub.docker.com/r/janus1990/docker-nginx-php/).

## Content

Nginx and PHP are compiled in a specific version. Consult the [CHANGELOG.md](./CHANGELOG.md) file
for further version details. [PHP Composer](https://getcomposer.org/) is already installed and ready
for use.

The Nginx and PHP-FPM master processes are controlled by [Honcho](https://github.com/nickstenning/honcho).
Honcho was chosen over Supervisor, because honcho will exit and kill the container if either Nginx
or PHP's master process dye for any reason. If you want have to have the container restarted
automatically, you may want to use
[Docker's restart](https://docs.docker.com/engine/reference/run/#restart-policies---restart) policy.

## Usage

```bash
docker run -v /path/to/php/source/:/usr/local/nginx/html/ janus1990/docker-nginx-php

# With restart policy
docker run --restart=always -v /path/to/php/source/:/usr/local/nginx/html/ janus1990/docker-nginx-php
```

## Advanced configuration

You by default, the image is configured to work out of the box, however you may add your own Nginx or
PHP related configuration files.

### Nginx

Mount your custom `nginx.conf` file at `/usr/local/nginx/conf/nginx.conf`.

`docker run -v /path/to/nginx.conf:/usr/local/nginx/conf/nginx.conf ... janus1990/docker-nginx-php`

### PHP & PHP-FPM

* Mount your custom `php-fpm.conf` file at `/usr/local/etc/php-fpm.conf`.
* Mount your custom `www.conf` file at `/usr/local/etc/www.conf`.
* Mount your custom `php.ini` file at `/usr/local/php/php.ini`.

### Honcho

If you want to overwrite the default Honcho configuration - mount your custom `Procfile` file at `/`.

## Todo

- Add [HEALTHCHECK](https://docs.docker.com/engine/reference/builder/#/healthcheck)
- Add more support for composer in docker entrypoint.
