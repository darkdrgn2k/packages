#!/bin/bash
# crossbuild-essential-armhf libc6-dev:armhf g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf

sudo apt-get update
sudo apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

wget https://dl.google.com/go/go1.11.linux-arm64.tar.gz 
sudo tar -C /usr/local -xzf go1.11.linux-arm64.tar.gz
rm -rf go1.11.linux-arm64.tar.gz

GOROOT=/usr/local/go


ARCHS="i386 amd64 armhf arm64 all"
#PKGS="babeld ipfs ipfs-tomesh"
PKGS="aether babeld babeld-tomesh confset"

for PKG in $PKGS; do

    for ARCH in $ARCHS; do
        export ARCH
        cd $PKG
        bash -x ./build.sh
        cd ..
    done
done
