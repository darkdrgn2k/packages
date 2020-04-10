#!/bin/bash

case "$ARCH" in
  all)
    PKG_ARCH="all"
  ;;
  *)
    exit 0
  ;;
esac

# Prep working directory
mkdir root
mkdir tmp
root=$(pwd)

# Prepare root directory
cp -R files/* root/
chmod 755 root/DEBIAN/postinst

version="1.1"

# Make deb pacakges
echo "Version: $version" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control

sudo chown -R root.root root
dpkg-deb --build root
sudo rm -rf root
mv root.deb ../yggdrasil-iptunnel-$version-$ARCH.deb

# Install and cleanup
rm -rf tmp
