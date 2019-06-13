#!/bin/bash

sudo apt-get update
sudo apt-get install -y \
    crossbuild-essential-armhf libc6-dev:armhf g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf 
    #gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
    #gcc-aarch64-linux-gnu g++-aarch64-linux-gnu  


ARCHS="armhf arm64 i386 amd64"
PKGS="ipfs ipfs-tomesh babeld babeld-tomesh"

PKGS="babeld"
ARCHS="i386 armhf"

for PKG in $PKGS; do

    for ARCH in $ARCHS; do
        export ARCH
        cd $PKG
        bash -x ./build.sh
        cd ..
    done
done

pwd
