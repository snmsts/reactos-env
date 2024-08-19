ZSTD_BRANCH ?= v1.5.6
VERSION ?= 2.2.6
VERSION_SUFFIX ?= .roswell
BRANCH ?= sbcl-$(VERSION)
SBCL_OPTIONS ?=--fancy --with-sb-core-compression --arch=x86
LISP_IMPL ?= sbcl
PACKAGE_ARCH ?= x86
PACKAGE_OS ?= reactos
PACKAGE_NAME ?= sbcl-$(VERSION)-$(PACKAGE_ARCH)-$(PACKAGE_OS)
SUFFIX ?=

all:

zstd:
	git clone --depth 5 https://github.com/facebook/zstd --branch=$(ZSTD_BRANCH)
	$(MAKE) -C zstd/lib
	cp zstd/lib/libzstd.a mingw/*/i686-w64-mingw32/lib
	cp zstd/lib/*.h mingw/*/i686-w64-mingw32/include

clean:
	rm -rf 7z winscp mingw sbcl build zstd

build/version.lisp-expr: build
	echo '"$(VERSION)$(VERSION_SUFFIX)$(SUFFIX)"' > $@

build:
	git clone --depth 5 https://github.com/sbcl/sbcl --branch=$(BRANCH) $@
	(test -f patch/$(VERSION) && sh -c "cd build; patch -p1 < ../patch/$(VERSION)") || true

compile: build
	$(MAKE) build/version.lisp-expr
	mv build/.git build/_git
	sh -c ". ~/sbcl-dev;cd build; sh make.sh $(SBCL_OPTIONS) --xc-host=\"$(LISP_IMPL)\" || mv _git .git"

archive: build
	cp -r build $(PACKAGE_NAME)
	bash build/binary-distribution.sh $(PACKAGE_NAME)
	mv $(PACKAGE_NAME) $(PACKAGE_NAME)-renamed
	tar xf $(PACKAGE_NAME)-binary.tar
	mv $(PACKAGE_NAME)/src/runtime/sbcl $(PACKAGE_NAME)/src/runtime/sbcl.exe
	tar czvf $(PACKAGE_NAME)-binary.tar.bz2 $(PACKAGE_NAME)
	rm -rf $(PACKAGE_NAME) $(PACKAGE_NAME)-binary.tar $(PACKAGE_NAME)-renamed
