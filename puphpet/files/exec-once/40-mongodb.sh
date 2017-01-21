#!/bin/sh
echo "---------------------------------------------"
echo "Applying bugfix for mongodb"
echo "---------------------------------------------"
mkdir -p /data/db
chmod 777 /data/db
cat <<EOT >> /etc/systemd/mongodb.service
[Unit]
Description=MongoDB Database Service
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/bin/mongod --config /etc/mongod.conf
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
User=mongodb
Group=mongodb
StandardOutput=syslog
StandardError=syslog

[Install]
WantedBy=multi-user.target
EOT
