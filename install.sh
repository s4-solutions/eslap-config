#!/bin/bash

if command -v nmcli >/dev/null 2>&1; then
    echo "NetworkManager installed"
else
    echo "NetworkManager not installed"

    sudo apt update
    sudo apt install -y network-manager

    sudo tee /etc/NetworkManager/NetworkManager.conf > /dev/null <<EOF
[main]
plugins=keyfile

[keyfile]
unmanaged-devices=type:ethernet
EOF

    sudo tee /etc/systemd/network/10-wifi.link > /dev/null <<EOF
[Match]
Type=wlan

[Link]
Name=wlan0
EOF
    sync

    sudo systemctl enable NetworkManager
    sudo systemctl start NetworkManager
fi

systemctl stop eslap-config
systemctl stop nginx

rm -rf /usr/lib/4seils

apt-get install -y nginx libpam0g-dev sshpass

rm -rf /tmp/4seils
mkdir /tmp/4seils

wget https://github.com/s4-solutions/eslap-config/raw/master/eslap-config.tgz

tar xvfz eslap-config.tgz -C /tmp/4seils

chown eslap-1118:eslap-1118 -R /tmp/4seils

cp -rf /tmp/4seils/static_files /home/eslap-1118/eslap/bin
cp -f /tmp/4seils/eslap-config /home/eslap-1118/eslap/bin
cp -f /tmp/4seils/eslap_config_pre.sh /home/eslap-1118/eslap/bin

chmod +x /home/eslap-1118/eslap/bin/eslap_config_pre.sh /home/eslap-1118/eslap/bin/eslap-config
chown eslap-1118:eslap-1118 /home/eslap-1118/eslap/bin/ -R

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
systemctl stop unattended-upgrades