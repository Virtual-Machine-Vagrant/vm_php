#!/bin/sh
echo "---------------------------------------------"
echo "Applying bugfix for mongodb"
echo "---------------------------------------------"
touch /var/run/mongod.pid
chown mongodb:mongodb /var/run/mongod.pid
service mongod restart
