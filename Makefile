BRANCH ?= sbcl-2.2.4
all:

clean:
	rm -rf 7z winscp mingw sbcl build
build:
	git clone --depth 5 https://github.com/sbcl/sbcl --branch=$(BRANCH) $@
	sh -c "cd build; patch -p1 < ../patch/$(BRANCH)"
	sh -c ". ~/sbcl-dev; cd build; sh make.sh --arch=x86"
