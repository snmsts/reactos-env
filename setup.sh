#!/bin/bash
RELEASE=release-0
_7Z_VERSION=24.08
SBCL_VERSION=1.3.0
MINGW_VERSION=8.1.0
WINSCP_VERSION=6.3.4

function install_winscp () {
if [[ ! -d winscp/$1 ]]; then
    mkdir -p winscp
    cd winscp && { curl -L -O https://github.com/snmsts/reactos-env/releases/download/$RELEASE/WinSCP-$1-Portable.zip ; cd -; }
    mkdir $1
    unzip winscp/WinSCP-$1-Portable.zip -d $1
    mv $1 winscp/$1
fi
}

function install_7z () {
if [[ ! -f 7z/bin/7zr.exe ]]; then 
    curl -L -O https://github.com/snmsts/reactos-env/releases/download/$RELEASE/7zr-$1.exe
    mkdir -p 7z/bin
    mv 7zr-$1.exe 7z/bin/7zr.exe
fi
}

function install_mingw () {
if [[ ! -d mingw/$1 ]]; then
    curl -L -O https://github.com/snmsts/reactos-env/releases/download/$RELEASE/i686-$1-release-win32-sjlj.7z
    7z/bin/7zr x i686-$1-release-win32-sjlj.7z
    rm i686-$1-release-win32-sjlj.7z
    mkdir -p mingw
    mv mingw32 mingw/$1
fi
}

function install_sbcl () {
if [[ ! -d sbcl/$1 ]]; then
    curl -L -O https://github.com/roswell/sbcl_bin/releases/download/$1/sbcl-$1-x86-reactos-binary.tar.bz2
    tar xf sbcl-$1-x86-reactos-binary.tar.bz2
    cd sbcl-$1-x86-reactos
    PATH=$PWD/../mingw/$MINGW_VERSION/bin:$PATH GNUMAKE=mingw32-make SBCL_HOME= sh install.sh --prefix=$PWD/../sbcl/$1
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
    grep "\. $1" ~/.bashrc > /dev/null || echo ". sbcl-dev" >> ~/.bashrc
}

install_winscp $WINSCP_VERSION
install_7z $_7Z_VERSION
install_mingw $MINGW_VERSION
install_sbcl $SBCL_VERSION
createrc sbcl-dev

