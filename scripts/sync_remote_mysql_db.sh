#!/usr/bin/env bash

PROJECT=pumpenscout

# Set timestamp
TIMESTAMP="$(date -u +%Y-%m-%d)"
FILENAME="backup_${PROJECT}_${TIMESTAMP}.sql"

SSH_HOST_FROM=pumpenscout.de
SSH_PORT_FROM=22
SSH_USER_FROM=wp12203392
MYSQL_HOST_FROM=localhost
MYSQL_USER_FROM=db12203392-psneu
MYSQL_DB_FROM=db12203392-psneu
MYSQL_PASS_FROM=psneupsneu
TMP_DIR_FROM="~/www/tmp/"
FILE_FROM=${TMP_DIR_FROM}${FILENAME}

SSH_HOST_TO=pumpenscout.de
SSH_PORT_TO=22
SSH_USER_TO=wp12203392
MYSQL_HOST_TO=localhost
MYSQL_USER_TO=db12203392-0001
MYSQL_DB_TO=db12203392-0001
MYSQL_PASS_TO=DSZ1OASzjTwI
TMP_DIR_TO="~/www/tmp/"
FILE_TO=${TMP_DIR_TO}${FILENAME}

TMP_DIR_LOCAL="/tmp/"
FILE_LOCAL=${TMP_DIR_LOCAL}${FILENAME}

echo "-------------------------------------"
echo "+ Creating backup of mysql database +"
echo "+ and importing it to another db.   +"
echo "-------------------------------------"
echo "  project:  ${PROJECT}"

# connect to remote host and create backup
ssh -T -p${SSH_PORT_FROM} ${SSH_USER_FROM}@${SSH_HOST_FROM} <<EOSSH
echo "  database: ${MYSQL_DB_FROM}"
echo ""
echo "  starting backup ..."
mysqldump -u${MYSQL_USER_FROM} -p${MYSQL_PASS_FROM} -h${MYSQL_HOST_FROM} --single-transaction --opt --no-data ${MYSQL_DB_FROM} > ${FILE_FROM}
mysqldump -u${MYSQL_USER_FROM} -p${MYSQL_PASS_FROM} -h${MYSQL_HOST_FROM} --single-transaction --opt --no-autocommit --ignore-table=${MYSQL_DB_FROM}.oxseo ${MYSQL_DB_FROM} >> ${FILE_FROM}
echo "  ... finished backup."
echo "  zipping ${FILE_FROM}"
gzip ${FILE_FROM}
EOSSH

if [ "${SSH_HOST_FROM}" != "${SSH_HOST_TO}" ]
	then
	# copy file from remote to local
	echo "  Copying ${FILE_FROM}.gz file to local system ${TMP_DIR_LOCAL}"
	scp -P${SSH_PORT_FROM} ${SSH_USER_FROM}@${SSH_HOST_FROM}:${FILE_FROM}.gz ${TMP_DIR_LOCAL}

	echo "  Copying ${FILE_LOCAL}.gz file to remote system ${TMP_DIR_TO}"
	scp -P${SSH_PORT_FROM} ${FILE_LOCAL}.gz ${SSH_USER_FROM}@${SSH_HOST_FROM}:${TMP_DIR_TO}
	rm ${FILE_LOCAL}
fi;

# connect to remote host and create backup
ssh -T -p ${SSH_PORT_TO} ${SSH_USER_TO}@${SSH_HOST_TO} <<EOSSH
echo "  database: ${MYSQL_DB_TO}"
echo "  unzipping ${FILE_TO}"
gunzip ${FILE_TO}.gz
sed -i 's/DEFINER=[^*]*\*/\*/g' ${FILE_TO}
echo "  Importing ${FILE_TO}"
mysql -u${MYSQL_USER_TO} -p${MYSQL_PASS_TO} -h${MYSQL_HOST_TO} ${MYSQL_DB_TO} < ${FILE_TO}
echo "  Delete ${FILE_TO}"
rm ${FILE_TO}
EOSSH