#!/bin/bash

case "$ARCH" in
  amd64)
    PKG_ARCH="amd64"
  ;;
  i386)
   exit 0
  ;;
  armhf)
     args="CC=arm-linux-gnueabihf-gcc"
     args="CXX=arm-linux-gnueabihf-g++"
  ;;
 arm64)
     export CC="aarch64-linux-gnu-gcc"
     export CXX="aarch64-linux-gnu-g++"
  ;;
  *)
    exit 0
  ;;
esac

version=0.0.1

# Prep working directory
mkdir root
root=$(pwd)

# Prepare root directory
cp -R files/* root/
chmod 755 root/DEBIAN/postinst

sudo apt-get install -y socat python-dev libtool python-setuptools autoconf automake

cd root
sudo sudo npm install ssb-server --target_arch=$ARCH --target_platform=linux --prefix `pwd` --global --unsafe-perms

cd ..

sudo chown -R root.root root

echo "Version: $version" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control
dpkg-deb --build root
sudo rm -rf root
mv root.deb ../ssb-$version-$ARCH.deb

# Install and cleanup
rm -rf tmp
