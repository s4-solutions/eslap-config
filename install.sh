#!/bin/bash

systemctl stop eslap-config
systemctl stop nginx

rm -rf /usr/lib/4seils

apt-get install -y nginx libpam0g-dev

rm -rf /tmp/4seils
mkdir /tmp/4seils

wget https://github.com/s4-solutions/eslap-config/raw/master/eslap-config.tgz

tar xvfz eslap-config.tgz -C /tmp/4seils

chown eslap-1118:eslap-1118 -R /tmp/4seils
chmod +x /tmp/4seils/eslap_pre.sh eslap-config

cp -rf /tmp/4seils/static_files /home/eslap-1118/eslap/bin
cp -f /tmp/4seils/eslap-config /home/eslap-1118/eslap/bin
cp -f /tmp/4seils/eslap_pre.sh /home/eslap-1118/eslap/bin

cp -f /tmp/4seils/nginx.conf /etc/nginx

cp -f /tmp/4seils/eslap-config.service /etc/systemd/system
systemctl daemon-reload

systemctl enable eslap-config
systemctl start eslap-config

systemctl stop nginx
systemctl start nginx

rm -f eslap-config.tgz
rm -rf /tmp/4seils

systemctl disable unattended-upgrades
