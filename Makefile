BRANCH ?= sbcl-2.2.4
all:

clean:
	rm -rf 7z winscp mingw sbcl build
build:
	git clone --depth 5 https://github.com/sbcl/sbcl --branch=$(BRANCH) $@
	cd build; patch -p1 < ../patch/$(BRANCH)
