BRANCH ?= sbcl-2.2.4
LISP_IMPL ?= sbcl

all:

clean:
	rm -rf 7z winscp mingw sbcl build
build:
	git clone --depth 5 https://github.com/sbcl/sbcl --branch=$(BRANCH) $@
	sh -c "cd build; patch -p1 < ../patch/$(BRANCH)"
	cat ~/sbcl-dev
	sh -c ". ~/sbcl-dev; echo $$PATH;cd build; sh make.sh --arch=x86 --xc-host=\"$(LISP_IMPL)\""
