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

# Install Vagrant for NATIVE compile

sudo apt-get install -y virtualbox --fix-missing
sudo wget -nv https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb
sudo dpkg -i vagrant_1.7.2_x86_64.deb  
  
ARCHS="i386 amd64 armhf arm64 all"

PKGS="babeld babeld-tomesh confset yggdrasil-iptunnel ssb aether"
PKGS="ssb"
ARCHS="armhf"

for PKG in $PKGS; do
    for ARCH in $ARCHS; do
        export ARCH
        cd $PKG
        bash -x ./build.sh
        cd ..
    done
done
