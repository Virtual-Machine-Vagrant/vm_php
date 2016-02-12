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

	echo "---------------------------------------------"
	echo "Changing php-fpm.conf for $version"
	echo "---------------------------------------------"	
		FILE=/opt/phpbrew/php/$version/etc/php-fpm.conf
		FIND="user = nobody"
		REPLACE="user = www-data"
		sed -i "s/$FIND/$REPLACE/g" $FILE
		
		FIND="group = nobody"
		REPLACE="group = www-data"
		sed -i "s/$FIND/$REPLACE/g" $FILE

		FIND="pm.max_children = 5"
		REPLACE="pm.max_children = 10"
		sed -i "s/$FIND/$REPLACE/g" $FILE	

	echo "---------------------------------------------"
	echo "Changing php.ini for $version"
	echo "---------------------------------------------"	
		FILE=/opt/phpbrew/php/$version/etc/php.ini
		FIND="memory_limit = 128M"
		REPLACE="memory_limit = 256M"
		sed -i "s/$FIND/$REPLACE/g" $FILE	

		FIND="upload_max_filesize = 2M"
		REPLACE="upload_max_filesize = 16M"
		sed -i "s/$FIND/$REPLACE/g" $FILE

		# FIND="smtp_port = 25"
		# REPLACE="smtp_port = 1025"
		# sed -i "s/$FIND/$REPLACE/g" $FILE	
done