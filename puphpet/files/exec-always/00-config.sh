#!/bin/sh
echo "---------------------------------------------"
echo "Sourcing config-file"
echo "---------------------------------------------"
source /vagrant/config.sh
echo "Required PHP versions: ${HOUSE_PHP_VERSIONS[*]}"
echo "Active PHP version: $HOUSE_PHP_ACTIVE_VERSION"