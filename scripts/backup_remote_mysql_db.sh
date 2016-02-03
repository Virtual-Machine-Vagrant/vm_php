source config.sh

# Set timestamp
TIMESTAMP="$(date -u +%Y-%m-%d)"
FILENAME="backup_${REMOTE_SQL_DB}_${TIMESTAMP}.sql"
REMOTE_TMP_DIR="/tmp/"
REMOTE_FILE=${REMOTE_TMP_DIR}${FILENAME}
LOCAL_TMP_DIR="/tmp/"
LOCAL_FILE=${LOCAL_TMP_DIR}${FILENAME}

# connect to remote host and create backup
ssh -T -p ${REMOTE_SSH_PORT} ${REMOTE_SSH_USER}@${REMOTE_HOST} <<EOSSH

echo "Creating backup of mysql database"
echo database      ${REMOTE_SQL_DB}

mysqldump -u${REMOTE_SQL_USER} -p${REMOTE_SQL_PASS} -h${REMOTE_SQL_HOST} ${REMOTE_SQL_DB} > ${REMOTE_FILE}

echo zipping ${REMOTE_FILE}
gzip ${REMOTE_FILE}
EOSSH

# copy file from remote to local, extract it
echo Copying ${REMOTE_FILE}.gz file to local system ${LOCAL_DIR}
scp -P${REMOTE_SSH_PORT} ${REMOTE_SSH_USER}@${REMOTE_HOST}:${REMOTE_FILE}.gz ${LOCAL_DIR}
gunzip ${LOCAL_FILE}

# import file to mysql
mysql -u${LOCAL_MYSQL_USER} -p${LOCAL_MYSQL_PASS} -h${LOCAL_MYSQL_HOST} ${LOCAL_MYSQL_DB} < ${LOCAL_FILE}

# delete file locally
rm ${LOCAL_FILE}

# delete file on remote host
ssh -T -p ${REMOTE_SSH_PORT} ${REMOTE_SSH_USER}@${REMOTE_HOST} <<EOSSH
rm ${REMOTE_FILE}.gz
EOSSH