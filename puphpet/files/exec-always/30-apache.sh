#!/bin/sh
echo ---------------------------------------------
echo Enabling Apache Modules
echo ---------------------------------------------
a2enmod headers
a2enmod vhost_alias

echo ---------------------------------------------
echo Fixing split-logfile
echo ---------------------------------------------

cd /usr/sbin
rm /usr/sbin/split-logfile
wget https://raw.githubusercontent.com/omnigroup/Apache/master/httpd/support/split-logfile.in
mv split-logfile.in split-logfile

echo ---------------------------------------------
echo Copy Apache Config
echo ---------------------------------------------

 cat <<EOT >> /etc/apache2/sites-available/30-dynamic-vhost.conf
 <VirtualHost *:80>
   ServerName house.local
   ServerAlias *.local
   VirtualDocumentRoot "/var/www/%0/web"

   <Directory "/var/www/%0">
     Options Indexes FollowSymlinks MultiViews
     AllowOverride All
     Require all granted
   </Directory>
   <FilesMatch "\.php$">
     Require all granted
     SetHandler proxy:fcgi://127.0.0.1:9000
   </FilesMatch>

   ## Logging
   ErrorLog "/var/log/apache2/error.log"
   CustomLog "/var/log/apache2/access.log" combined

   ## SetEnv/SetEnvIf for environment variables
   SetEnv APP_ENV dev
   SetEnv SHOPWARE_ENV local
   SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1
   ## Custom fragment
 </VirtualHost>
EOT
a2ensite 30-dynamic-vhost.conf
service apache2 restart
