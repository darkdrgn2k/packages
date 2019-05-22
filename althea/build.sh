#!/bin/bash

mkdir root
mkdir tmp
cd tmp

curl https://sh.rustup.rs -sSf | sh -s -- -y
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
PATH=$PATH:$HOME/.cargo/bin
sudo apt-get install -y build-essential libssl-dev

git clone https://github.com/althea-mesh/althea_rs.git
cd althea_rs
cd scripts

case "$ARCH" in
  amd64)
    ./linux_build_static.sh
  ;;
  i386)
    ./linux_build_static.sh
  ;;
  armhf)
    ./openwrt_build_mvebu.sh
    mkdir ../root/sbin
    cp ./target-arm_cortex-a9+vfpv3_musl_eabi/root-mvebu/usr/sbin/rita ../root/sbin
  ;;
  arm64)
    ./openwrt_build_mvebu.sh
    mkdir ../root/sbin
    cp ./target-arm_cortex-a9+vfpv3_musl_eabi/root-mvebu/usr/sbin/rita ../root/sbin
  ;;
  *)
    echo "Unknown Arch"
    exit 1
  ;;
esac

