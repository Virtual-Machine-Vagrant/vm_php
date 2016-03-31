#!/usr/bin/env bash
CONFIG_LOADED=false
source _load_config.sh

echo "-------------------------------------"
echo "+ Initializing new project          +"
echo "-------------------------------------"

REQUIRED_PARAMETER=(LOCAL_PROJECT_URL GIT_CLONE_URL)
source _require_parameters.sh

SCRIPT_PATH="$(pwd)"
mkdir -p "/var/www/${LOCAL_PROJECT_URL}"
cd "/var/www/${LOCAL_PROJECT_URL}"

if [ ! -d "/var/www/${LOCAL_PROJECT_URL}/${GIT_CLONE_FOLDER}" ]
  then
    git clone ${GIT_CLONE_URL} ${GIT_CLONE_FOLDER}
    ln -s ${GIT_CLONE_FOLDER} web
  else
    echo "  ⚠  Folder already exits: /var/www/${LOCAL_PROJECT_URL}/${GIT_CLONE_FOLDER}"
fi

cd ${SCRIPT_PATH}
./create_database.sh $1
./backup_remote_mysql_db.sh $1
./rsync_folders.sh $1
