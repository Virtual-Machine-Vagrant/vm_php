#!/bin/sh
echo "---------------------------------------------"
echo "Sourcing config-file"
echo "---------------------------------------------"
source /vagrant/config.sh
echo "Required PHP versions: ${HOUSE_PHP_VERSIONS[*]}"
echo "Active PHP version: $HOUSE_PHP_ACTIVE_VERSION"


echo "---------------------------------------------"
echo "Enabling password authentication via ssh"
echo "---------------------------------------------"
FILE=/etc/ssh/sshd_config
LINE="PasswordAuthentication no"
sed -i "/$LINE/d" $FILE
LINE="#PasswordAuthentication yes"
sed -i "/$LINE/d" $FILE
LINE="PasswordAuthentication yes"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
service ssh restart

echo "---------------------------------------------"
echo "Setting password for user vagrant"
echo "User: vagrant"
echo "Password: vagrant"
echo "---------------------------------------------"
usermod --password TRg15Tz.1Xlkg vagrant