VERSION ?= 2.2.4
ZSTD_BRANCH ?= v1.5.6
BRANCH ?= sbcl-$(VERSION)
LISP_IMPL ?= sbcl
PACKAGE_ARCH ?= x86
PACKAGE_OS ?= reactos
PACKAGE_NAME ?= sbcl-$(VERSION)-$(PACKAGE_ARCH)-$(PACKAGE_OS)
all:

zstd:
	git clone --depth 5 https://github.com/facebook/zstd --branch=$(ZSTD_BRANCH)
	$(MAKE) -C zstd/lib
	cp zstd/lib/libzstd.a mingw/*/i686-w64-mingw32/lib
	cp zstd/lib/*.h mingw/*/i686-w64-mingw32/include

clean:
	rm -rf 7z winscp mingw sbcl build
build:
	git clone --depth 5 https://github.com/sbcl/sbcl --branch=$(BRANCH) $@
	(test -f patch/$(BRANCH) && sh -c "cd build; patch -p1 < ../patch/$(BRANCH)") || true
	cat ~/sbcl-dev

compile: build
	sh -c ". ~/sbcl-dev;cd build; sh make.sh --arch=x86 --xc-host=\"$(LISP_IMPL)\""
archive: build
	cp -r build $(PACKAGE_NAME)
	bash build/binary-distribution.sh $(PACKAGE_NAME)
	rm -rf $(PACKAGE_NAME)
	tar xf $(PACKAGE_NAME)-binary.tar
	mv $(PACKAGE_NAME)/src/runtime/sbcl $(PACKAGE_NAME)/src/runtime/sbcl.exe
	tar czvf $(PACKAGE_NAME)-binary.tar.bz2 $(PACKAGE_NAME)
	rm -rf $(PACKAGE_NAME) $(PACKAGE_NAME)-binary.tar
