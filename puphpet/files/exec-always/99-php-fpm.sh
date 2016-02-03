echo "---------------------------------------------"
echo "Stopping system php-fpm"
echo "---------------------------------------------"
service php5-fpm stop
echo "---------------------------------------------"
echo "Starting phpbrew php-fpm instead"
echo "---------------------------------------------"
phpbrew fpm restart