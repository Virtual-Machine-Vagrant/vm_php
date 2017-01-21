#!/bin/sh
echo ---------------------------------------------
echo Setting Apache User to vagrant
echo ---------------------------------------------
APACHEUSER=vagrant
APACHEGROUP=vagrant
sed -i "s/^\(User\s*\).*\$/\1$APACHEUSER/" /etc/apache2/apache2.conf
sed -i "s/^\(Group\s*\).*\$/\1$APACHEGROUP/" /etc/apache2/apache2.conf
service apache2 restart

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

rm /etc/apache2/sites-available/25-vhost_house_local.conf
cat <<EOT >> /etc/apache2/sites-available/25-vhost_house_local.conf
<VirtualHost *:80>
   ServerName house.local
   ServerAlias www.house.local

   ## Vhost docroot
   DocumentRoot "/var/www/house.local"

   <Directory "/var/www/house.local">
     Options Indexes FollowSymlinks MultiViews
     AllowOverride All
     Require all granted

     <FilesMatch "\.php$">
       Require all granted
       SetHandler proxy:fcgi://127.0.0.1:9000
     </FilesMatch>
   </Directory>
  <LocationMatch "/(ping|status)$">
   Options Indexes
   Require all granted
   SetHandler proxy:fcgi://127.0.0.1:9000
  </LocationMatch>
   ErrorLog "/var/log/apache2/vhost_house_local_error.log"
   ServerSignature Off
   CustomLog "/var/log/apache2/vhost_house_local_access.log" combined

   ## SetEnv/SetEnvIf for environment variables
   SetEnv APP_ENV dev
   SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1
 </VirtualHost>
EOT

 cat <<EOT >> /etc/apache2/sites-available/30-dynamic-vhost.conf
  <Directory "/var/www">
   AllowOverride All
   Allow from All
 </Directory>
 <VirtualHost *:80>
   ServerName house.local
   ServerAlias *.local
   ServerAlias *.local.pttde.de
   VirtualDocumentRoot "/var/www/%0/web"

   <Directory "/var/www/%0">
     Options Indexes FollowSymlinks MultiViews
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
