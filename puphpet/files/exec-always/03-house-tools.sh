#!/bin/sh
rm -rf /var/www/html
HOUSE_PATH=/var/www/house.local
HOUSE_TOOLS_PATH=/var/www/house.local/tools
echo "---------------------------------------------"
echo "Installing tools into $HOUSE_TOOLS_PATH"
echo "---------------------------------------------"
rm -rf $HOUSE_TOOLS_PATH
mkdir -p $HOUSE_TOOLS_PATH
ln -s $HOUSE_TOOLS_PATH /var/www/html

echo "---------------------------------------------"
echo "Elasticsearch: Installing elasticsearch HQ"
echo "---------------------------------------------"
cd $HOUSE_TOOLS_PATH
git clone https://github.com/royrusso/elasticsearch-HQ.git > /dev/null 2>&1

echo "---------------------------------------------"
echo "MongoDB: Installing genghis"
echo "---------------------------------------------"
GENGHIS_PATH=$HOUSE_TOOLS_PATH/genghis
mkdir -p $GENGHIS_PATH
cd $GENGHIS_PATH
wget https://raw.githubusercontent.com/bobthecow/genghis/master/genghis.php > /dev/null 2>&1

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
