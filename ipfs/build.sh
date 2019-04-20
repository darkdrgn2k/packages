#!/bin/bash
GO_IPFS_VERSION="0.4.20"

case "$ARCH" in
  amd64)
    PKG_ARCH="amd64"
  ;;
  i386)
    PKG_ARCH="386"
  ;;
  armhf)
    PKG_ARCH="arm";
  ;;
  arm64)
    PKG_ARCH="arm64";
  ;;
  *)
    echo "Unknown Arch"
    exit 1
  ;;
esac

# prepare root directory
mkdir root
mkdir tmp
wget "https://dist.ipfs.io/go-ipfs/v${GO_IPFS_VERSION}/go-ipfs_v${GO_IPFS_VERSION}_linux-${PKG_ARCH}.tar.gz" -O "tmp/go-ipfs.tar.gz"
tar xvfz "tmp/go-ipfs.tar.gz" -C "tmp"
mkdir -p root/usr/bin
cp "tmp/go-ipfs/ipfs" root/usr/bin/ipfs
rm -rf "tmp"

mkdir -p root/lib/systemd/system
cp "ipfs.service" root/lib/systemd/system/ipfs.service

rm -rf tmp

# Control Files
mkdir root/DEBIAN
cat << EOF  > root/DEBIAN/control
Package: IPFS
Version: $GO_IPFS_VERSION
Maintainer: Darkdrgn2k
Architecture: $ARCH
Description: "BLABLABLA"
EOF

cat << EOF  > root/DEBIAN/postinst
# Post install script
adduser ipfs
sudo chown ipfs:ipfs root/usr/bin/ipfs
sudo systemctl daemon-reload
sudo systemctl enable ipfs.service
sudo systemctl start ipfs.service
ipfs init || true
EOF
chmod a+x root/DEBIAN/postinst
dpkg-deb --build root
rm -rf root
mv root.deb ../IPFS-$GO_IPFS_VERSION-$ARCH.deb
