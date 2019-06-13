#!/bin/bash

case "$ARCH" in
  amd64)
    PKG_ARCH="amd64"
  ;;
  i386)
    PKG_ARCH="386"
  ;;
  armhf)
    PKG_ARCH="arm";
    CC=arm-linux-gnueabihf-gc
  ;;
  arm64)
    exit 0
    PKG_ARCH="arm64";
  ;;
  *)
    echo "Unknown Arch"
    exit 1
  ;;
esac

# Prep working directory
mkdir root
mkdir tmp

# Prepare root directory
cp -R files/* root/
chmod 755 root/DEBIAN/postinst

git clone git://github.com/jech/babeld.git /tmp/babeld/tmp
cd tmp
sed -i 's|PREFIX = /usr/local|PREFIX = $(pwd)/../root/ |' Makefile
make
make install
cd ..
rm -rf tmp

# Make deb pacakges
version="$(root/bin/babeld -V  2>&1)"
version=${version:7}
echo "Version: $version" >> root/DEBIAN/control
#echo "Architecture: $( dpkg --print-architecture)" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control

dpkg-deb --build root
rm -rf root
mv root.deb ../BABELD-$version-$ARCH.deb

# Install and cleanup
cd ..
rm -rf tmp
