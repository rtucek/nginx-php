[![Build Status](https://travis-ci.org/rtucek/nginx-php.svg?branch=master)](https://travis-ci.org/rtucek/nginx-php) [![Docker Repository on Quay](https://quay.io/repository/rtucek/nginx-php/status "Docker Repository on Quay")](https://quay.io/repository/rtucek/nginx-php) [![](https://images.microbadger.com/badges/image/rtucek/nginx-php.svg)](https://microbadger.com/images/rtucek/nginx-php "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/rtucek/nginx-php.svg)](https://microbadger.com/images/rtucek/nginx-php "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/rtucek/nginx-php.svg)](https://microbadger.com/images/rtucek/nginx-php "Get your own commit badge on microbadger.com")

## nginx-php Dockerfile

This repository contains source code of
[rtucek/nginx-php](https://hub.docker.com/r/rtucek/nginx-php).

## Content

Nginx and PHP are compiled in a specific version. Consult the
[CHANGELOG.md](https://github.com/rtucek/nginx-php/blob/master/CHANGELOG.md)
file for further version details. [PHP Composer](https://getcomposer.org/) is
already installed and ready for use.

Xdebug is installed as shared extension, but not activated. Start the container
with env ENABLE_XDEBUG=1 to enable the extension.

The Nginx and PHP-FPM master processes are controlled by
[Honcho](https://github.com/nickstenning/honcho). Honcho was chosen over
Supervisor, because honcho will exit and kill the container if either Nginx or
PHP's master process dye for any reason. If you want have to have the container
restarted automatically, you may want to use
[Docker's restart](https://docs.docker.com/engine/reference/run/#restart-policies---restart)
policy.

## Usage

```bash
docker run -v /path/to/php/source/:/usr/local/nginx/html/ rtucek/nginx-php

# With restart policy
docker run --restart=always -v /path/to/php/source/:/usr/local/nginx/html/ rtucek/nginx-php
```

## Advanced configuration

You by default, the image is configured to work out of the box, however you may
add your own Nginx or PHP related configuration files.

### Nginx

Mount your custom `nginx.conf` file at `/usr/local/nginx/conf/nginx.conf`.

`docker run -v /path/to/nginx.conf:/usr/local/nginx/conf/nginx.conf ... rtucek/nginx-php`

### PHP & PHP-FPM

* Mount your custom `php-fpm.conf` file at `/usr/local/etc/php-fpm.conf`.
* Mount your custom `www.conf` file at `/usr/local/etc/www.conf`.
* Mount your custom `php.ini` file at `/usr/local/php/php.ini`.

### Xdebug

Xdebug was installed mainly with the idea of providing code coverage for
PHPUnit. Thus it's not configured for any specific use case. You can
[configure Xdebug](https://xdebug.org/docs/all) via `php.ini` if desired.

### Crontab

Crontab is already installed. In order to deploy a crontab file, you would need
to store a valid crontab file to `/crontab/USERNAME`, where `USERNAME` has to
be an **existing** user. This is important, because any contrab instructions
will be executed as the user, specified by the filename.

Usually, you would like to run all your crontab instructions as **www-data**.
So you should mount your crontab file to `/crontab/www-data` (or under
`/crontab/root` if needed - needless to say you should try to avoid this
whenever possible).

### Honcho

If you want to overwrite the default Honcho configuration - mount your custom
`Procfile` file at `/`.

## Todo

- Add [HEALTHCHECK](https://docs.docker.com/engine/reference/builder/#/healthcheck)
