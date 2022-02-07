APT_PROXY ?=
DOCKER ?= docker

all:

build:
	$(DOCKER) build --build-arg APT_PROXY="$(APT_PROXY)" -t ghcr.io/seravo/flask:latest .

run: build
	$(DOCKER) run --rm -p 127.0.0.1:8080:8080 -d ghcr.io/seravo/flask:latest
