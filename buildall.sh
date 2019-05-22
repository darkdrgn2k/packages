#!/bin/bash

ARCHS="armhf arm64 i386 amd64"
PKGS="althea ipfs ipfs-tomesh"
for PKG in $PKGS; do

    for ARCH in $ARCHS; do
        export ARCH
        cd $PKG
        bash ./build.sh
        cd ..
    done
done

ls -la *.deb
