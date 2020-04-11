#!/bin/bash
export chroot="/"
case "$ARCH" in
  amd64)
      exit;
  ;;
  i386)
      export chroot="/"
  ;;
  armhf)
     export chroot="/opt/rpifs/"
  ;;
 arm64)
     export chroot="/opt/armbianfs/"
  ;;
  *)
    exit 0
  ;;
esac

version=0.0.2

# Prep working directory
mkdir root
root=$(pwd)

# Prepare root directory
cp -a files/* root/
chmod 755 root/DEBIAN/postinst


current=`pwd`;
mkdir root

(cd $chroot
cat << EOF | sudo chroot . 
set -x 

sudo mkdir ssb
cd ssb

#sudo sudo sudo npm install --target_arch=$ARCH --target_platform=linux --prefix `pwd` --global --unsafe-perm=true sodium-native@2.4.2
#--target_arch=$ARCH --target_platform=linux 
sudo sudo npm install --prefix /ssb --global --unsafe-perm=true ssb-server
cd ..
exit
EOF
)
mkdir root/usr
sudo cp -a $chroot/ssb/* root/usr

echo "Version: $version" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control
sudo chown -R root.root root

dpkg-deb --build root

sudo rm -rf root
mv root.deb ../ssb-$version-$ARCH.deb

# Install and cleanup
rm -rf tmp
