#!/bin/bash
source /vagrant/config.sh
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

setUserAndGroupForFPM() {
	PHPVERSION=$1
	PHP_MAJOR_VERSION=$(echo $PHPVERSION| cut -d'.' -f 1)
	PHP_MINOR_VERSION=$(echo $PHPVERSION| cut -d'.' -f 2)
	PHP_VERSION_MM=$PHP_MAJOR_VERSION.$PHP_MINOR_VERSION

	FILE=/opt/phpbrew/php/php-$1/etc/php-fpm.conf
	if [ "$PHP_MAJOR_VERSION" -lt "7" ]
		then
			FILE=/opt/phpbrew/php/php-$1/etc/php-fpm.conf
		else
			FILE=/opt/phpbrew/php/php-$1/etc/php-fpm.d/www.conf
	fi

	echo "---------------------------------------------"
	echo "Setting user and group for php-fpm"
	echo "---------------------------------------------"
	REPLACE="vagrant"
	sed -i "s/^\(user\s*=\s*\).*\$/\1$REPLACE/" $FILE
	sed -i "s/^\(group\s*=\s*\).*\$/\1$REPLACE/" $FILE
	
	echo "---------------------------------------------"
	echo "Setting listen to port 9000"
	echo "FILE $FILE"
	echo "---------------------------------------------"		
	REPLACE="9000"
	sed -i "s/^\(listen\s*=\s*\).*\$/\1$REPLACE/" $FILE
}

setPhpIniValues() {
	PHPVERSION=$1
	PHP_MAJOR_VERSION=$(echo $PHPVERSION| cut -d'.' -f 1)
	PHP_MINOR_VERSION=$(echo $PHPVERSION| cut -d'.' -f 2)
	PHP_VERSION_MM=$PHP_MAJOR_VERSION.$PHP_MINOR_VERSION

	echo "---------------------------------------------"
	echo "Setting php.ini sendmail_path to use mailhog"
	echo "---------------------------------------------"
	FILE=/opt/phpbrew/php/php-$1/etc/php.ini
	SEARCH=";sendmail_path"
	REPLACE="sendmail_path"
	sed -i "s/$SEARCH/$REPLACE/g" $FILE
	REPLACE="mailhog sendmail -t -i"
	sed -i "s/^\(sendmail_path\s*=\s*\).*\$/\1$REPLACE/" $FILE

	echo "---------------------------------------------"
	echo "Setting php.ini smtp-port to mailhog 1025"
	echo "---------------------------------------------"    
	SEARCH=";smtp_port"
	REPLACE="smtp_port"
	sed -i "s/$SEARCH/$REPLACE/g" $FILE
	REPLACE="1025"
	sed -i "s/^\(smtp_port\s*=\s*\).*\$/\1$REPLACE/" $FILE
}

service php7.1-fpm stop
for i in ${HOUSE_PHP_VERSIONS[@]}; do
	echo "Running for $i"
	setUserAndGroupForFPM $i
	setPhpIniValues $i
done

switch_php ${HOUSE_PHP_ACTIVE_VERSION}
