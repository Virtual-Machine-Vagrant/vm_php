#!/bin/sh
echo "---------------------------------------------"
echo "Updating composer"
echo "---------------------------------------------"
composer self-update
echo "---------------------------------------------"
echo "Installing composer parallel plugin"
echo "---------------------------------------------"
composer global require hirak/prestissimo
