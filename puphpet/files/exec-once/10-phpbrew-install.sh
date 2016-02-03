# system wide installation of phpbrew 
echo "---------------------------------------------"
echo "Downloading phpbrew"
echo "---------------------------------------------"
cd /tmp
curl -L -O -s https://github.com/phpbrew/phpbrew/raw/master/phpbrew
chmod +x phpbrew
mv phpbrew /usr/local/bin/phpbrew

echo "---------------------------------------------"
echo "Settings phpbrew paths"
echo "---------------------------------------------"
LINE="export PHPBREW_ROOT=/opt/phpbrew"
FILE=/etc/profile.d/phpbrew.sh
touch $FILE
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
LINE="export PHPBREW_HOME=/opt/phpbrew"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
source /etc/profile.d/phpbrew.sh
echo PHPBREW_ROOT=$PHPBREW_ROOT
echo PHPBREW_HOME=$PHPBREW_HOME
echo "---------------------------------------------"
echo "Initializing phpbrew"
echo "---------------------------------------------"
phpbrew init

LINE="source /opt/phpbrew/bashrc"
FILE=/etc/profile.d/phpbrew.sh
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
source /etc/profile.d/phpbrew.sh