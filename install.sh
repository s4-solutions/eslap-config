#!/bin/bash

systemctl stop eslap-config
systemctl stop nginx

apt-get install -y nginx libpam0g-dev

rm -rf /usr/lib/4seils
mkdir /usr/lib/4seils

wget https://github.com/s4-solutions/eslap-config/raw/master/eslap-config.tgz

tar xvfz eslap-config.tgz -C /usr/lib/4seils

cp /usr/lib/4seils/nginx.conf /etc/nginx

cp /usr/lib/4seils/eslap-config.service /etc/systemd/system
systemctl daemon-reload

systemctl enable eslap-config
systemctl start eslap-config

systemctl stop nginx
systemctl start nginx



