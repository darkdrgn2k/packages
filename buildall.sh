#!/bin/bash
# crossbuild-essential-armhf libc6-dev:armhf g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf 

sudo apt-get update
sudo apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf 
sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu  


ARCHS="i386 amd64 armhf arm64"
PKGS="babeld ipfs ipfs-tomesh"


for PKG in $PKGS; do

    for ARCH in $ARCHS; do
        export ARCH
        cd $PKG
        bash -x ./build.sh
        cd ..
    done
done
