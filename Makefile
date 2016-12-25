REPO = janus1990
IMAGE = docker-nginx-php
VERSION = 0.2.0
EXTRAVERSION =

IMAGE_FQN = $(REPO)/$(IMAGE):v$(VERSION)$(EXTRAVERSION)

.PHONY: build

default:	build

build:
	docker build -t $(IMAGE_FQN) .
