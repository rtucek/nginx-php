REPO = janus1990
IMAGE = docker-nginx-php
VERSION = 0.1.0
EXTRAVERSION = -dev

IMAGE_FQN = $(REPO)/$(IMAGE):$(VERSION)$(EXTRAVERSION)

.PHONY: build

default:	build

build:
	docker build -t $(IMAGE_FQN) .

# tag_latest:
    # docker tag -f $(NAME):$(VERSION) $(NAME):latest
