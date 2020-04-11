#!/bin/bash

case "$ARCH" in
  amd64)
    PKG_ARCH="amd64"
  ;;
  i386)
  ;;
  armhf)
     export chroot="/opt/rpifs/"
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


current=`pwd`;

if ! [ -z "$chroot" ]; then
    cd $chroot
    sudo chroot .
    sudo mkdir 1
fi

sudo mkdir root
sudo apt-get install -y socat python-dev libtool python-setuptools autoconf automake

cd root
#sudo sudo sudo npm install --target_arch=$ARCH --target_platform=linux --prefix `pwd` --global --unsafe-perm=true sodium-native@2.4.2
sudo npm install --target_arch=$ARCH --target_platform=linux --prefix `pwd` --global --unsafe-perm=true ssb-server
cd ..

if ! [ -z "$chroot" ]; then    
    exit
    cp -r $chroot/root/ $currnet/root/
    rm -rf $chroot/root
fi

echo "Version: $version" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control
sudo chown -R root.root root

dpkg-deb --build root

sudo rm -rf root
mv root.deb ../ssb-$version-$ARCH.deb

# Install and cleanup
rm -rf tmp
