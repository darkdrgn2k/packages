#!/bin/bash
NODE_EXPORTER_VERSION="0.18.1"

case "$ARCH" in
  amd64)
    PKG_ARCH="amd64"
  ;;
  i386)
    PKG_ARCH="386"
  ;;
  armhf)
    PKG_ARCH="armv7";
  ;;
  arm64)
    PKG_ARCH="arm64";
  ;;
  *)
    echo "Unknown Arch"
    exit 1
  ;;
esac

#node_exporter-0.18.1.linux-arm64.tar.gz



# prepare root directory
mkdir root
mkdir tmp
wget "https://dist.ipfs.io/go-ipfs/v${GO_IPFS_VERSION}/go-ipfs_v${GO_IPFS_VERSION}_linux-${PKG_ARCH}.tar.gz" -O "tmp/go-ipfs.tar.gz"
wget "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-arm${ARM_VERSION}.tar.gz" -O "tmp/node_exporter.tar.gz"

tar xvfz "tmp/node_exporter.tar.gz" -C "tmp"
mkdir -p root/usr/bin
cp "tmp/node_exporter/node_exporter" root/usr/bin/node_exporter
mkdir -p root/var/lib/node_exporter/ 

mkdir -p root/lib/systemd/system
cp "node-exporter.service" root/lib/systemd/system/node-exporter.service

rm -rf tmp



# Control Files
mkdir root/DEBIAN
cat << EOF  > root/DEBIAN/control
Package: node-exporter
Version: $NODE_EXPORTER_VERSION
Maintainer: Darkdrgn2k
Architecture: $ARCH
Description: "BLABLABLA"
EOF

cat << EOF  > root/DEBIAN/postinst
# Post install script
sudo chown root:staff root/usr/bin/node_exporter

sudo systemctl daemon-reload
sudo systemctl enable node-exporter.service
sudo systemctl start node-exporter.service
EOF
chmod a+x root/DEBIAN/postinst
dpkg-deb --build root
rm -rf root
mv root.deb ../node-exporter-$NODE_EXPORTER_VERSION-$ARCH.deb
