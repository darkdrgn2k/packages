#!/bin/bash
# crossbuild-essential-armhf libc6-dev:armhf g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf

sudo apt-get update unzip
sudo apt-get install curl haveged
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
sudo apt-get install -y nodejs npm

# I think some stuff for SSB
sudo apt-get install -y python-dev libtool python-setuptools autoconf automake

GOROOT=/usr/local/go

# FS
if ! [ -f "020-02-13-raspbian-buster-lite.img " ]; then
  sudo apt-get install qemu qemu-user-static binfmt-support
  wget https://downloads.raspberrypi.org/raspbian_lite_latest -O rip.zip
  unzip rip.zip
fi
SECTORSTART=532480
sudo mkdir 1
sudo mount -o loop,offset=$((512*$SECTORSTART)) 2020-02-13-raspbian-buster-lite.img 1
sudo cp /usr/bin/qemu-arm-static 1/usr/bin  #Allow chroot
sudo mkdir /opt/rpifs
sudo cp -a 1/. /opt/rpifs
sudo ls -la /opt/rpifs
sudo umount 1

sudo mount --bind /dev /opt/rpifs/dev/
sudo mount --bind /sys /opt/rpifs/sys/
sudo mount --bind /proc /opt/rpifs/proc/
sudo mount --bind /dev/pts /opt/rpifs/dev/pts

# Install NodeJS in RPIFS
(cd /opt/rpifs
cat << EOF | sudo chroot . 
sudo rm -rf /etc/ld.so.preload 
sudo touch /etc/ld.so.preload 

NODEJS_PREFIX=10
NODEJS_VERSION="$NODEJS_PREFIX.15.3"
curl -sL https://deb.nodesource.com/setup_$NODEJS_PREFIX.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y socat python-dev libtool python-setuptools autoconf automake haveged
exit
EOF
)

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
