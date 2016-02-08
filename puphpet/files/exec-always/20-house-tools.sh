#!/bin/sh
rm -rf /var/www/html
HOUSE_PATH=/var/www/house.local
HOUSE_TOOLS_PATH=/var/www/house.local/tools
mkdir -p $HOUSE_TOOLS_PATH
echo "---------------------------------------------"
echo "Installtion tools into $HOUSE_TOOLS_PATH"
echo "---------------------------------------------"

echo "---------------------------------------------"
echo "Elasticsearch: Installing elasticsearch HQ"
echo "---------------------------------------------"
cd $HOUSE_TOOLS_PATH
git clone https://github.com/royrusso/elasticsearch-HQ.git

echo "---------------------------------------------"
echo "MongoDB: Installing genghis"
echo "---------------------------------------------"
GENGHIS_PATH=$HOUSE_TOOLS_PATH/genghis
mkdir -p $GENGHIS_PATH
cd $GENGHIS_PATH
wget https://raw.githubusercontent.com/bobthecow/genghis/master/genghis.php

echo "---------------------------------------------"
echo "MySQL: Installing adminer"
echo "---------------------------------------------"
ADMINER_PATH=$HOUSE_TOOLS_PATH/adminer
mkdir -p $ADMINER_PATH
cd $ADMINER_PATH
wget https://www.adminer.org/latest-mysql.php