#!/bin/bash

case "$ARCH" in
  amd64)
    PKG_ARCH="amd64"
     args="CC=aarch64-linux-gnu-gcc"
  ;;
  i386)
    PKG_ARCH="386"
  ;;
  armhf)
    PKG_ARCH="arm";
    args="CC=arm-linux-gnueabihf-gcc"
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
root=$(pwd)

# Prepare root directory
cp -R files/* root/
chmod 755 root/DEBIAN/postinst

git clone git://github.com/jech/babeld.git tmp
cd tmp
sed -i "s|PREFIX = /usr/local|PREFIX = $root/root/|" Makefile
make $args
make install $args 
cd ..
rm -rf tmp

# Make deb pacakges
if [ -f "../version.txt" ]; then
    version="$(cat ../version.txt)"
else
    version="$(root/bin/babeld -V  2>&1)"
    version=${version:7}
    echo $version > ../version.txt
fi

echo "Version: $version" >> root/DEBIAN/control
#echo "Architecture: $( dpkg --print-architecture)" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control

dpkg-deb --build root
rm -rf root
mv root.deb ../BABELD-$version-$ARCH.deb

# Install and cleanup
rm -rf tmp
