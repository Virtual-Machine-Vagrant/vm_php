#!/bin/bash
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

echo "---------------------------------------------"
echo "Setting Swap Size to 4GB"
echo "---------------------------------------------"
# size of swapfile in megabytes
swapsize=4000

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
  echo 'swapfile not found. Adding swapfile.'
  fallocate -l ${swapsize}M /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap defaults 0 0' >> /etc/fstab
else
  echo 'swapfile found. No changes made.'
fi

# output results to terminal
df -h
cat /proc/swaps
cat /proc/meminfo | grep Swap