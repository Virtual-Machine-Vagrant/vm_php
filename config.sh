#!/bin/sh
# house.local config file
export HOUSE_PHP_VERSIONS=(5.3.29)		# separated by space, the first version will be the default version
# 5.3.29 5.4.45 5.5.31 
export HOUSE_PHP_ACTIVE_VERSION=${HOUSE_PHP_VERSIONS[0]}