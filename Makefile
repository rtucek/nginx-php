REPO = janus1990
IMAGE = docker-nginx-php
VERSION = 0.1.0
EXTRAVERSION = -RC1

IMAGE_FQN = $(REPO)/$(IMAGE):v$(VERSION)$(EXTRAVERSION)

.PHONY: build

default:	build

build:
	docker build -t $(IMAGE_FQN) .
