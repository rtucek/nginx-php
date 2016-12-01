## nginx-php Dockerfile

This repository contains source code of [janus1990/docker-nginx-php/](https://hub.docker.com/r/janus1990/docker-nginx-php/).

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

## Todo

- Add [HEALTHCHECK](https://docs.docker.com/engine/reference/builder/#/healthcheck)
- Extend [README.md](./README.md) with configuration (Procfile, nginx.conf...).
- Add more support for composer in docker entrypoint.
