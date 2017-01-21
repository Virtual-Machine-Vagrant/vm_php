#!/bin/bash
source /vagrant/config.sh
echo "---------------------------------------------"
echo "Setting php.ini smtp-port to mailhog 1025"
echo "---------------------------------------------"
FILE=/etc/mysql/my.cnf
SEARCH="skip-external-locking"
REPLACE="#skip-external-locking"
sed -i "s/$SEARCH/$REPLACE/g" $FILE

SEARCH="bind-address"
REPLACE="#bind-address"
sed -i "s/$SEARCH/$REPLACE/g" $FILE

service mariadb restart
