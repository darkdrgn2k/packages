#!/bin/bash

case "$ARCH" in
  amd64)
    PKG_ARCH="amd64"
  ;;
  i386)
   exit 0
  ;;
  armhf)
   exit 0
  ;;
  arm64)
    exit 0
  ;;
  *)
    exit 0
  ;;
esac

$version=0.0.1

## Move into main build
NODEJS_PREFIX=10
NODEJS_VERSION="$NODEJS_PREFIX.15.3"
curl -sL https://deb.nodesource.com/setup_$NODEJS_PREFIX.x | sudo -E bash -
apt-get install -y nodejs

# Prep working directory
mkdir root
root=$(pwd)

# Prepare root directory
cp -R files/* root/
chmod 755 root/DEBIAN/postinst

sudo apt-get install -y socat python-dev libtool python-setuptools autoconf automake

cd root
sudo sudo npm install ssb-server --prefix `pwd` --global
cd ..

sudo chown -R root.root root

dpkg-deb --build root
sudo rm -rf root
mv root.deb ../ssb-$version-$ARCH.deb

# Install and cleanup
rm -rf tmp
