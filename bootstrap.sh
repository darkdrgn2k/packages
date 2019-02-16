#!/usr/bin/env bash
sudo apt update
sudo apt install -y \
apt-transport-https \
build-essential \
ca-certificates \
curl \
git

# CJDNS
TAG_CJDNS=d2e55d58548d83940482fe1bbbe1fd36f7f1b4ef
CJDNS_BUILD_CMD="sudo Seccomp_NO=1 ./do"

mkdir cjdns
cd cjdns

git clone https://github.com/cjdelisle/cjdns.git cjdns-src
cd cjdns-src
git checkout $TAG_CJDNS
eval $CJDNS_BUILD_CMD

mkdir -p ../usr/bin
cp cjdroute ../usr/bin

mkdir -p ../usr/share/cjdns
cp -R tools ../usr/share/cjdns/
cp -R node_modules ../usr/share/cjdns/
cp privatetopublic  ../usr/share/cjdns
cp publictoip6  ../usr/share/cjdns

mkdir -p ../lib/systemd/system
cp contrib/systemd/cjdns.service ../lib/systemd/system/cjdns.service
cp contrib/systemd/cjdns-resume.service ../lib/systemd/system/cjdns-resume.service
sudo chmod 644 ../lib/systemd/system/cjdns-resume.service
sudo chmod 644 ../lib/systemd/system/cjdns.service

cd ..


mkdir DEBIAN
cat << EOF  > DEBIAN/control
Package: CJDNS-neon
Version: 3.0 
Maintainer: darkdrgn2k 
Architecture: armhf
Description: CJDNS with Neon accel $TAG_CJDNS
EOF
cat << EOF  > DEBIAN/postinst
#!/bin/bash
if ! [ -f "/etc/cjdroute.conf" ]; then
    sudo /usr/bin/cjdroute --genconf | sudo tee --append /etc/cjdroute.conf > /dev/null
fi
systemctl daemon-reload
systemctl enable cjdns.service
EOF

chmod a+x DEBIAN/postinst
rm -rf cjdns-src
cd ..
dpkg-deb --build cjdns
mv cjdns.deb cjdns-neon-v4.deb
