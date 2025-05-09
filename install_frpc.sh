#!/bin/bash

wget https://github.com/s4-solutions/eslap-config/raw/master/frpc
cp -f frpc /home/eslap-1118/eslap/bin
chmod 755 /home/eslap-1118/eslap/bin/frpc

wget https://github.com/s4-solutions/eslap-config/raw/master/frpc.service
cp -f frpc.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable frpc

FILE="/home/eslap-1118/eslap/config/device.yaml"

if grep -q "dongle" "$FILE"; then
    echo "this is dongle"
else
  SUDOERS_FILE="/etc/sudoers.d/eslap-1118"
  ENTRY="eslap-1118 ALL=NOPASSWD: /usr/bin/systemctl restart frpc.service"

  if grep -q "frpc.service" "$SUDOERS_FILE"; then
      echo "already added"
  else
      echo "$ENTRY" | sudo tee -a "$SUDOERS_FILE" > /dev/null
  fi
fi

sync
