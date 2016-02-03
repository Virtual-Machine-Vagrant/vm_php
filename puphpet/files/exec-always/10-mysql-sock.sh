echo "---------------------------------------------"
echo "Creating symlink for mysql.sock"
echo "---------------------------------------------"
service mysql stop
MYSQL_SOCK=$(mysql_config --socket)
ln -sf $MYSQL_SOCK /tmp/mysql.sock
service mysql start