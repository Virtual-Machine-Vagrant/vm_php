#!/bin/bash

rm /etc/bash.houselocal
cat <<EOT >> /etc/bash.houselocal
echo " _                            _                 _ "
echo "| |__   ___  _   _ ___  ___  | | ___   ___ __ _| |"
echo "| '_ \ / _ \| | | / __|/ _ \ | |/ _ \ / __/ _  | |"
echo "| | | | (_) | |_| \__ \  __/_| | (_) | (_| (_| | |"
echo "|_| |_|\___/ \__,_|___/\___(_)_|\___/ \___\__,_|_|"
echo ""

 source /etc/profile.d/phpbrew.sh
EOT

LINE="source /etc/bash.houselocal"
FILE=/etc/bash.bashrc
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"