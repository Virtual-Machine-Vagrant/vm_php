#!/bin/sh
echo ---------------------------------------------
echo Enabling Apache Modules
echo ---------------------------------------------
a2enmod headers
service apache2 restart