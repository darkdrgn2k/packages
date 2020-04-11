#!/bin/bash
export chroot="/"
case "$ARCH" in
  amd64)
  ;;
  i386)
  ;;
  armhf)
     export chroot="/opt/rpifs/"
  ;;
 arm64)
     export chroot="/opt/rpifs/"
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
mkdir root

(cd $chroot
cat << EOF | sudo chroot . 

sudo mkdir root

cd root
#sudo sudo sudo npm install --target_arch=$ARCH --target_platform=linux --prefix `pwd` --global --unsafe-perm=true sodium-native@2.4.2
#--target_arch=$ARCH --target_platform=linux 
npm install --prefix `pwd` --global --unsafe-perm=true ssb-server
cd ..
exit
EOF
)
sudo ls -la /opt/rpifs
sudo ls -la /opt/rpifs/root/

sudo cp -r $chroot/root/* root
sudo cp -r /opt/rpifs/root/* root


echo "Version: $version" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control
sudo chown -R root.root root

dpkg-deb --build root

sudo rm -rf root
mv root.deb ../ssb-$version-$ARCH.deb

# Install and cleanup
rm -rf tmp
