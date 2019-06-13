#!/bin/bash

apt-get install -y gcc-arm-linux-gnueabihf

ARCHS="armhf arm64 i386 amd64"
PKGS="ipfs ipfs-tomesh babeld babeld-tomesh"

PKGS="babeld"
ARCHS="armhf"

for PKG in $PKGS; do

    for ARCH in $ARCHS; do
        export ARCH
        cd $PKG
        bash ./build.sh
        cd ..
    done
done

pwd
