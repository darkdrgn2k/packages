#!/bin/bash

case "$ARCH" in
  any)
    PKG_ARCH="any"
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

version=1

# Make deb pacakges
echo "Version: $version" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control

sudo chown -R root.root root
dpkg-deb --build root
sudo rm -rf root
mv root.deb ../confget-$version-$ARCH.deb

# Install and cleanup
rm -rf tmp
