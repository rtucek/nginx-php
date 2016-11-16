REPO = rtucek
IMAGE = nginx-php
VERSION = 0.1.0

IMAGE_FQN = $(REPO)/$(IMAGE):$(VERSION)

.PHONY: build

default:	build

build:
	docker build -t $(IMAGE_FQN) .

# tag_latest:
    # docker tag -f $(NAME):$(VERSION) $(NAME):latest
