#!/usr/bin/env sh
if [ $1 ] && [ -f "config/$1.sh" ]
  then
      source config/$1.sh
      if [ -z "${GIT_CLONE_FOLDER}" ]
      then
        GIT_CLONE_FOLDER=$(basename ${GIT_CLONE_URL})
        GIT_CLONE_FOLDER=${GIT_CLONE_FOLDER/\.git/}
      fi
  else
    echo "------------------------------------"
  	echo "+ ⚠  No config loaded!             +"
  	echo "  !  Check if config/$1.sh exists."
    echo "------------------------------------"
  	exit;
fi
