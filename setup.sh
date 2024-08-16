#!/bin/bash

SBCL_VERSION=2.0.8
MINGW_VERSION=8.1.0

function install_7z () {
if [[ ! -f 7z/bin/7zr.exe ]]; then 
    curl -L -O https://www.7-zip.org/a/7zr.exe
    mkdir -p 7z/bin
    mv 7zr.exe 7z/bin
fi
}

function install_mingw () {
if [[ ! -d mingw/$1 ]]; then
    curl -L -O https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/$1/threads-win32/sjlj/i686-$1-release-win32-sjlj-rt_v6-rev0.7z
    7z/bin/7zr x i686-$1-release-win32-sjlj-rt_v6-rev0.7z
    rm i686-$1-release-win32-sjlj-rt_v6_rev.7z
    mkdir -p mingw
    mv mingw32 mingw/$1
fi
}

function install_sbcl () {
if [[ ! -d sbcl/$1 ]]; then
    curl -L -O https://github.com/roswell/sbcl_bin/releases/download/$1/sbcl-$1-x86-reactos-binary.tar.bz2
    tar xf sbcl-$1-x86-reactos-binary.tar.bz2
    cd sbcl-$1-x86-reactos
    SBCL_HOME= sh install.sh --prefix=$PWD/../sbcl/$1
    cd ..; rm -rf sbcl-$1-x86-reactos sbcl-$1-x86-reactos-binary.tar.bz2
fi
}

function createrc () {
    echo "INSTALL_PATH=$PWD" > ~/$1
    echo "export PATH=\"\$INSTALL_PATH/7z/bin:\$PATH\"" >> ~/$1
    echo "export PATH=\"\$INSTALL_PATH/sbcl/$SBCL_VERSION/bin:\$PATH\"" >> ~/$1
    echo "export PATH=\"\$INSTALL_PATH/mingw/$MINGW_VERSION/bin:\$PATH\"" >> ~/$1
    echo "export SBCL_HOME=\$INSTALL_PATH/sbcl/$SBCL_VERSION/lib/sbcl" >> ~/$1
    echo "export GNUMAKE=mingw32-make" >> ~/$1
}

install_7z
install_mingw $MINGW_VERSION
install_sbcl $SBCL_VERSION
createrc sbcl-dev

grep "\. sbcl-dev" ~/.bashrc > /dev/null || echo ". sbcl-dev" >> ~/.bashrc
