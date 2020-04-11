#!/bin/bash
# crossbuild-essential-armhf libc6-dev:armhf g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf

sudo apt-get update

sudo apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf # ARM  Cross COmpiler
sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu  # ARM64 Cross Compiler

# Go Dev Environment
wget https://dl.google.com/go/go1.11.linux-arm64.tar.gz 
sudo tar -C /usr/local -xzf go1.11.linux-arm64.tar.gz
rm -rf go1.11.linux-arm64.tar.gz

# NODE JS
NODEJS_PREFIX=10
NODEJS_VERSION="$NODEJS_PREFIX.15.3"
curl -sL https://deb.nodesource.com/setup_$NODEJS_PREFIX.x | sudo -E bash -
sleep 1
sudo apt-get install -y nodejs

# I think some stuff for SSB
sudo apt-get install -y python-dev libtool python-setuptools autoconf automake

GOROOT=/usr/local/go

# FS
wget https://downloads.raspberrypi.org/raspbian_lite_latest -O rip.zip
unzip rip.zip
SECTORSTART=532480
sudo mkdir 1
sudo mount -o loop,offset=$((512*$SECTORSTART)) 2020-02-13-raspbian-buster-lite.img 1
sudo cp /usr/bin/qemu-arm-static 1/usr/bin  #Allow chroot
sudo mkdir /opt/rpifs
sudo cp -r 1/ /opt/rpifs
sudo ls -la /opt/rpifs
sudo umount 1


ARCHS="i386 amd64 armhf arm64 all"

PKGS="babeld babeld-tomesh confset yggdrasil-iptunnel ssb aether"
PKGS="ssb"

for PKG in $PKGS; do
    for ARCH in $ARCHS; do
        export ARCH
        cd $PKG
        bash -x ./build.sh
        cd ..
    done
done
