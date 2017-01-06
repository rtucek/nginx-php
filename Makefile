REPO = rtucek
IMAGE = nginx-php
VERSION = 0.3.1
EXTRAVERSION =

IMAGE_FQN = $(REPO)/$(IMAGE):v$(VERSION)$(EXTRAVERSION)

.PHONY: build

default:	build

build:
	docker build -t $(IMAGE_FQN) .

test-build:
	docker build -t testbuild .
