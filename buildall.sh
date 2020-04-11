#!/bin/bash
# crossbuild-essential-armhf libc6-dev:armhf g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf

sudo apt-get update unzip
sudo apt-get install curl haveged
sudo apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf # ARM  Cross COmpiler
sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu  # ARM64 Cross Compiler
sudo /usr/sbin/haveged --Foreground --verbose=1 -w 1024 &

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

sudo apt-get install qemu qemu-user-static binfmt-support

# ARM32 - Using Raspberry Pi Image
if ! [ -f "2020-02-13-raspbian-buster-lite.img" ]; then
  wget https://downloads.raspberrypi.org/raspbian_lite_latest -O rip.zip
  unzip rip.zip
fi
SECTORSTART=532480
sudo mkdir 1
sudo mount -o loop,offset=$((512*$SECTORSTART)) 2020-02-13-raspbian-buster-lite.img 1
sudo mkdir /opt/rpifs
sudo cp -a 1/. /opt/rpifs
sudo ls -la /opt/rpifs
sudo cp /usr/bin/qemu-arm-static /opt/rpifs/usr/bin  #Allow chroot
sudo umount 1

#sudo mount --bind /dev /opt/rpifs/dev/
#sudo mount --bind /sys /opt/rpifs/sys/
#sudo mount --bind /proc /opt/rpifs/proc/
#sudo mount --bind /dev/pts /opt/rpifs/dev/pts

# Install NodeJS in RPIFS
sudo mkdir -p /opt/rpifs/dev
sudo mknod /opt/rpifs/dev/urandom c 1 9
sudo chmod 0666 /opt/rpifs/dev/urandom

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

# ARM64 - Using Rock64 Image
if ! [ -f "Armbian_20.02.1_Rock64_buster_legacy_4.4.213.img" ]; then
  sudo apt-get install p7zip
  wget wget https://dl.armbian.com/rock64/archive/Armbian_20.02.1_Rock64_buster_legacy_4.4.213.7z -O Armbian_20.02.1_Rock64_buster_legacy_4.4.213.7z
  7zr x Armbian_20.02.1_Rock64_buster_legacy_4.4.213.7z
fi
SECTORSTART=32768
sudo mkdir 1
sudo mount -o loop,offset=$((512*$SECTORSTART)) Armbian_20.02.1_Rock64_buster_legacy_4.4.213.img 1
sudo mkdir /opt/armbianfs
sudo cp -a 1/. /opt/armbianfs
sudo ls -la /opt/armbianfs
sudo cp /usr/bin/qemu-arm-static /opt/armbianfs/usr/bin  #Allow chroot
sudo umount 1

# Install NodeJS 
sudo mkdir -p /opt/armbianfs/dev
sudo mknod /opt/armbianfs/dev/urandom c 1 9
sudo chmod 0666 /opt/armbianfs/dev/urandom

(cd /opt/armbianfs
ls -la bin
ls -la bin/bash
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
ARCHS="armhf arm64"

for PKG in $PKGS; do
    for ARCH in $ARCHS; do
        export ARCH
        cd $PKG
        bash -x ./build.sh
        cd ..
    done
done
