#!/bin/bash
rm -rf /var/www/html
HOUSE_PATH=/var/www/house.local
HOUSE_TOOLS_PATH=/var/www/house.local/tools
echo "---------------------------------------------"
echo "House Web Interface"
echo "---------------------------------------------"
cp -r /var/www-nfs/www/house.local /var/www

echo "---------------------------------------------"
echo "Installing tools into $HOUSE_TOOLS_PATH"
echo "---------------------------------------------"
rm -rf $HOUSE_TOOLS_PATH
mkdir -p $HOUSE_TOOLS_PATH
ln -s $HOUSE_TOOLS_PATH /var/www/html

echo "---------------------------------------------"
echo "MongoDB: Installing "
echo "---------------------------------------------"
MONGODB_PATH=$HOUSE_TOOLS_PATH/mongoWebAdmin
mkdir -p $MONGODB_PATH
cd $MONGODB_PATH
wget http://downloads.sourceforge.net/project/mongo-web-admin/mongoWebAdmin-beta6.tar.gz > /dev/null 2>&1
tar -zxvf mongoWebAdmin-beta6.tar.gz

echo "---------------------------------------------"
echo "MySQL: Installing adminer"
echo "---------------------------------------------"
ADMINER_PATH=$HOUSE_TOOLS_PATH/adminer
mkdir -p $ADMINER_PATH
cd $ADMINER_PATH
wget https://www.adminer.org/latest-mysql.php > /dev/null 2>&1

echo "---------------------------------------------"
echo "Beanstalk Web Interface"
echo "---------------------------------------------"
composer create-project ptrofimov/beanstalk_console -s dev ${HOUSE_TOOLS_PATH}/beanstalk
