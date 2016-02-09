#!/bin/sh
source /vagrant/config.sh
install_php() {
	PHPVERSION=$1
	PHP_MAJOR_VERSION=$(echo $PHPVERSION| cut -d'.' -f 1)
	PHP_MINOR_VERSION=$(echo $PHPVERSION| cut -d'.' -f 2)
	PHP_VERSION_MM=$PHP_MAJOR_VERSION.$PHP_MINOR_VERSION
	JOBS=$(nproc)

	echo "---------------------------------------------"
	echo "installation of php via homebrew"
	echo "VERSION: $PHP_VERSION_MM ($PHPVERSION)"
	echo "MAJOR VERSION: $PHP_MAJOR_VERSION"
	echo "MINOR VERSION: $PHP_MINOR_VERSION"
	echo "---------------------------------------------"
	source /etc/profile.d/phpbrew.sh

	PHP_MODULES="+default +fpm +dbs +iconv +ipv6 +mcrypt +openssl +soap +intl +gd=shared +mysql +ftp +session +zip"
	if [ $PHP_VERSION_MM == 5.5 ] || [ $PHP_VERSION_MM == 5.6 ]
	then
	   PHP_MODULES="$PHP_MODULES +opcache"
	fi

	phpbrew install --jobs=$JOBS $PHPVERSION $PHP_MODULES -- --with-mysql-sock=/var/run/mysqld/mysqld.sock
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

	echo "---------------------------------------------"
	echo "installing extension ioncube"
	echo "---------------------------------------------"
	LINE="zend_extension=/opt/ioncube/ioncube_loader_lin_$PHP_VERSION_MM.so"
	FILE=/opt/phpbrew/php/php-$PHPVERSION/var/db/00-ioncube.ini
	touch $FILE
	grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
	echo "---------------------------------------------"
	echo "installing extension: zend guard loader"
	echo "---------------------------------------------"
	LINE="zend_extension=/opt/zendguard/php$PHP_VERSION_MM/ZendGuardLoader.so"
	FILE=/opt/phpbrew/php/php-$PHPVERSION/var/db/10-zendguardloader.ini
	touch $FILE
	grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

	if [ $PHP_VERSION_MM == 5.5 ] || [ $PHP_VERSION_MM == 5.6 ]
	then
	   LINE="zend_extension=/opt/zendguard/php$PHP_VERSION_MM/opcache.so"
		FILE=/opt/phpbrew/php/php-$PHPVERSION/var/db/11-zend_opcache.ini
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
        phpbrew fpm stop
		phpbrew switch $1
        phpbrew fpm start
}

install_zendguardAndIoncube() {
	echo "---------------------------------------------"
	echo "Copying Zendguard and Ioncube files"
	echo "---------------------------------------------"
cd /opt
rm -rf /opt/zendguard
rm -rf /opt/ioncube
cp -rf /vagrant/puphpet/files/install/* /opt
rm -rf /opt/ioncube
wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -zxf ioncube_loaders_lin_x86-64.tar.gz
rm ioncube_loaders_lin_x86-64.tar.gz
}

service php5-fpm stop
install_zendguardAndIoncube
for i in ${HOUSE_PHP_VERSIONS[@]}; do
	install_php $i
done

switch_php ${HOUSE_PHP_ACTIVE_VERSION}
