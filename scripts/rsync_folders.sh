#!/usr/bin/env bash
source _load_config.sh

echo "------------------------------------"
echo "+ Running RSYNC                    +"
echo "------------------------------------"

REQUIRED_PARAMETER=(REMOTE_SSH_USER REMOTE_HOST)
source _require_parameters.sh

for remote_folder in "${!RSYNC_FOLDERS[@]}"; do
	echo "  from: $remote_folder"
	echo "  to: ${RSYNC_FOLDERS[$remote_folder]}"
	rsync -rlDzhP -e "ssh -p ${REMOTE_SSH_PORT}" --stats --owner=www-data --group=www-data ${REMOTE_SSH_USER}@${REMOTE_HOST}:$remote_folder ${RSYNC_FOLDERS[$remote_folder]}
done
