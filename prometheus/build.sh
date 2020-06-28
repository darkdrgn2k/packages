#!/bin/bash

PROMETHEUS_VERSION="2.19.2"

case "$ARCH" in
  amd64)
    PKG_ARCH="amd64"
    ARCH="amd64"
  ;;
  i386)
    PKG_ARCH="386"
    ARCH="386"
  ;;
  armhf)
    PKG_ARCH="arm";
    ARCH="armv7";
  ;;
  arm64)
    PKG_ARCH="arm64";
    ARCH="arm64";
  ;;
  *)
    exit 0
  ;;
esac

mkdir tmp
wget "https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-${ARCH}.tar.gz" -O "tmp/prometheus.tar.gz"
mkdir root
mkdir root/opt
mkdir root/opt/prometheus
cp -R files/* root/
tar xvfz "tmp/prometheus.tar.gz" -C "root/opt/prometheus" --strip 1

echo "Version: $PROMETHEUS_VERSION" >> root/DEBIAN/control
#echo "Architecture: $( dpkg --print-architecture)" >> root/DEBIAN/control
echo Architecture: $ARCH >> root/DEBIAN/control

chmod 755 root/DEBIAN/postinst
sudo chown -R root.root root
dpkg-deb --build root
sudo rm -rf root
mv root.deb ../prometheus-$version-$ARCH.deb

# Install and cleanup
rm -rf tmp
