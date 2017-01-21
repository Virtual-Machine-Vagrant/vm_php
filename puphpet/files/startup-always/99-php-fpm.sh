#!/bin/bash
source /etc/profile.d/phpbrew.sh
echo "---------------------------------------------"
echo "Stopping system php-fpm"
echo "---------------------------------------------"
service php7.1-fpm stop
echo "---------------------------------------------"
echo "Starting phpbrew php-fpm instead"
echo "---------------------------------------------"
phpbrew fpm restart
