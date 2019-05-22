#!/bin/bash
GO_IPFS_VERSION="0.4.20" 

# prepare root directory
mkdir root

# Control Files
mkdir root/DEBIAN
cat << EOF  > root/DEBIAN/control
Package: IPFS-tomesh
Version: $GO_IPFS_VERSION
Maintainer: darkdrgn2k
Architecture: $ARCH
Description: "BLABLABLA"
Depends: ipfs (= $GO_IPFS_VERSION)
EOF

cat << EOF  > root/DEBIAN/postinst
# Post install script
# Enable gossipsub routing
ipfs config Pubsub.Router gossipsub
# Enable Filestore for --nocopy capability
ipfs config --bool Experimental.FilestoreEnabled true
EOF
chmod a+x root/DEBIAN/postinst
dpkg-deb --build root
rm -rf root
mv root.deb ../IPFS-tomesh-$GO_IPFS_VERSION-$ARCH.deb
