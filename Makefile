REPO = rtucek
IMAGE = nginx-php
VERSION = 1.0.0
EXTRAVERSION = -unreleased-wip

IMAGE_FQN = $(REPO)/$(IMAGE):$(VERSION)$(EXTRAVERSION)

.PHONY: build

default:	build

build:
	docker build -t $(IMAGE_FQN) .

# tag_latest:
    # docker tag -f $(NAME):$(VERSION) $(NAME):latest
