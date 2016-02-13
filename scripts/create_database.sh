#!/usr/bin/env bash
source _load_config.sh

echo "------------------------------------"
echo "+ Creating mysql database          +"
echo "------------------------------------"

REQUIRED_PARAMETER=(LOCAL_MYSQL_DB LOCAL_MYSQL_DB_COLLATION)
source _require_parameters.sh

echo "  database: ${LOCAL_MYSQL_DB}"
mysql -uroot -phouse -e "CREATE DATABASE IF NOT EXISTS \`${LOCAL_MYSQL_DB}\` COLLATE ${LOCAL_MYSQL_DB_COLLATION}"
