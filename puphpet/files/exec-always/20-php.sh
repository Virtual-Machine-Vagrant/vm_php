#!/bin/bash
source /vagrant/config.sh
install_php() {
	PHPVERSION=$1
	PHP_MAJOR_VERSION=$(echo $PHPVERSION| cut -d'.' -f 1)
	PHP_MINOR_VERSION=$(echo $PHPVERSION| cut -d'.' -f 2)
	PHP_VERSION_MM=$PHP_MAJOR_VERSION.$PHP_MINOR_VERSION
	JOBS=$(nproc)

	echo "---------------------------------------------"
	echo "installation of php via phpbrew"
	echo "VERSION: $PHP_VERSION_MM ($PHPVERSION)"
	echo "MAJOR VERSION: $PHP_MAJOR_VERSION"
	echo "MINOR VERSION: $PHP_MINOR_VERSION"
	echo "---------------------------------------------"
	source /etc/profile.d/phpbrew.sh

	PHP_MODULES="+default +curl +fpm +dbs +iconv +ipv6 +mcrypt +openssl +soap +intl +gd=shared +mysql +ftp +session +zip"

	phpbrew install --jobs=$JOBS --no-clean $PHPVERSION $PHP_MODULES -- --with-mysql-sock=/var/run/mysqld/mysqld.sock --with-fpm-user=vagrant --with-fpm-group=vagrant
	echo "---------------------------------------------"
	echo "switching to php-version $PHPVERSION"
	echo "---------------------------------------------"
	source /etc/profile.d/phpbrew.sh
	phpbrew switch $PHPVERSION
	echo "---------------------------------------------"
	echo "installing extension: xdebug"
	echo "---------------------------------------------"
	XDEBUG_VERSION=stable
	if [ $PHP_VERSION_MM == 5.3 ]
	then
	   XDEBUG_VERSION=2.2.7 
	fi
	install_php_ext xdebug $XDEBUG_VERSION

	echo "---------------------------------------------"
	echo "installing extension: gd"
	echo "---------------------------------------------"
	install_php_ext gd

	echo "---------------------------------------------"
	echo "installing extension: mongo"
	echo "---------------------------------------------"
	install_php_ext mongo

	APCU_VERSION=stable
	if [ $PHP_VERSION_MM == 5.3 ] || [ $PHP_VERSION_MM == 5.4 ] || [ $PHP_VERSION_MM == 5.5 ] || [ $PHP_VERSION_MM == 5.6 ] 
	then
	   APCU_VERSION=4.0.10 
	fi
	install_php_ext apcu $APCU_VERSION

	echo "---------------------------------------------"
	echo "installing extension ioncube"
	echo "---------------------------------------------"
	LINE="zend_extension=/opt/ioncube/ioncube_loader_lin_$PHP_VERSION_MM.so"
	FILE=/opt/phpbrew/php/php-$PHPVERSION/var/db/00-ioncube.ini
	touch $FILE
	grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"


	ZENDGUARDFILE=/opt/zendguard/php$PHP_VERSION_MM/ZendGuardLoader.so
	if [ -f "$ZENDGUARDFILE" ]
	then
		echo "---------------------------------------------"
		echo "installing extension: zend guard loader"
		echo "---------------------------------------------"
		LINE="zend_extension=/opt/zendguard/php$PHP_VERSION_MM/ZendGuardLoader.so"
		FILE=/opt/phpbrew/php/php-$PHPVERSION/var/db/10-zendguardloader.ini
		touch $FILE
		grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
	fi

	echo "---------------------------------------------"
	echo "installing extension: opcache"
	echo "---------------------------------------------"
	if [ $PHP_VERSION_MM == 5.5 ] || [ $PHP_VERSION_MM == 5.6 ]
	then
	   	LINE="zend_extension=/opt/zendguard/php$PHP_VERSION_MM/opcache.so"
		FILE=/opt/phpbrew/php/php-$PHPVERSION/var/db/11-opcache.ini
		touch $FILE
		grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
	fi
}

install_php_ext() {
	phpbrew ext install $1 $2

	string=$(phpbrew extension show $1 | grep 'Loaded')
	if printf -- '%s' "$string" | egrep -q -- "no"
		then
			echo "---------------------------------------------"
			echo "Enabling extension $1"
			echo "---------------------------------------------"
			phpbrew extension enable $1
	fi
}

switch_php() {
	echo "---------------------------------------------"
	echo "switching to php-version $1"
	echo "---------------------------------------------"
		rm /var/www/house.local/status.html
		ln -s /opt/phpbrew/php/${HOUSE_PHP_ACTIVE_VERSION}/php/php/fpm/status.html /var/www/house.local/status.html
        phpbrew fpm stop
		phpbrew switch $1
        phpbrew fpm start
}

install_zendguardAndIoncube() {
	echo "---------------------------------------------"
	echo "Copying Zendguard files"
	echo "---------------------------------------------"
	cd /opt
	rm -rf /opt/zendguard
	rm -rf /opt/ioncube
	cp -rf /vagrant/puphpet/files/install/zendguard /opt
	echo "---------------------------------------------"
	echo "Downloading Ioncube files"
	echo "---------------------------------------------"
	wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz > /dev/null 2>&1
	tar -zxf ioncube_loaders_lin_x86-64.tar.gz
	rm ioncube_loaders_lin_x86-64.tar.gz
}

setUserAndGroupForFPM() {
	PHPVERSION=$1
	PHP_MAJOR_VERSION=$(echo $PHPVERSION| cut -d'.' -f 1)
	PHP_MINOR_VERSION=$(echo $PHPVERSION| cut -d'.' -f 2)
	PHP_VERSION_MM=$PHP_MAJOR_VERSION.$PHP_MINOR_VERSION

	echo "---------------------------------------------"
	echo "Setting user and group for php-fpm"
	echo "---------------------------------------------"

	FILE=/opt/phpbrew/php/php-$1/etc/php-fpm.conf
	if [ -f "$FILE" ]
		then
			FILE=/opt/phpbrew/php/php-$1/etc/php-fpm.conf
		else
			FILE=/opt/phpbrew/php/php-$1/etc/php-fpm.d/www.conf	
	fi		
	
	REPLACE="vagrant"
	sed -i "s/^\(user\s*=\s*\).*\$/\1$REPLACE/" $FILE
	sed -i "s/^\(group\s*=\s*\).*\$/\1$REPLACE/" $FILE
	echo "---------------------------------------------"
	echo "Setting listen to port 9000"
	echo "---------------------------------------------"		
	REPLACE="9000"
	sed -i "s/^\(listen\s*=\s*\).*\$/\1$REPLACE/" $FILE
}

service php7.1-fpm stop
install_zendguardAndIoncube
for i in ${HOUSE_PHP_VERSIONS[@]}; do
	install_php $i
	setUserAndGroupForFPM $i
done

switch_php ${HOUSE_PHP_ACTIVE_VERSION}