#!/usr/bin/env bash
source config.sh
echo "Loading Shopware Media Folder"
rsync -avz ${REMOTE_SSH_USER}@${REMOTE_HOST}:${REMOTE_SHOPWARE_MEDIA_FOLDER} ${LOCAL_SHOPWARE_FOLDER}
