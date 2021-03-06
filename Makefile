DOCKER = docker
XZ     = xz

IMAGE   := conreality/docker
VERSION := $(shell cat VERSION)
SOURCES := $(wildcard .docker/* etc/* usr/local/*/*)

all: build

.built: Dockerfile $(SOURCES)
	$(DOCKER) build -t $(IMAGE) -f $< .
	@touch $@

dist.tar.xz: .built
	$(DOCKER) save $(IMAGE) | $(XZ) -1 > $@

build: .built

check:
	@echo "not implemented" && false # TODO

dist: dist.tar.xz

install: .built

uninstall:
	$(DOCKER) image rm $(IMAGE) || true

clean:
	@rm -f .built *~

distclean: clean

mostlyclean: clean

boot: .built
	$(DOCKER) run --rm -it -p22:22/tcp $(IMAGE) init

exec-shell: .built
	$(DOCKER) run --rm -it $(IMAGE) /bin/sh

.PHONY: check uninstall clean distclean mostlyclean
.PHONY: boot exec-shell
.SECONDARY:
.SUFFIXES:
