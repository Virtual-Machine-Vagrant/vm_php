#!/bin/sh
source /etc/profile.d/phpbrew.sh
echo "---------------------------------------------"
echo "Stopping system php-fpm"
echo "---------------------------------------------"
service php5-fpm stop
echo "---------------------------------------------"
echo "Starting phpbrew php-fpm instead"
echo "---------------------------------------------"
phpbrew list | sed "s/[ \*]//g" | while read version ; do
    phpbrew fpm restart $version
done