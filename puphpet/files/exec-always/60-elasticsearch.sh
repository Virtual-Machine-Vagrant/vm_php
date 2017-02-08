#!/bin/bash

echo "---------------------------------------------"
echo "Elasticsearch: Installing elasticsearch HQ"
echo "---------------------------------------------"
cd $HOUSE_TOOLS_PATH
git clone https://github.com/royrusso/elasticsearch-HQ.git > /dev/null 2>&1

echo "---------------------------------------------"
echo "Configuring Elasticsearch for external access"
echo "---------------------------------------------"
FILE=/etc/elasticsearch/es-01/elasticsearch.yml
LINE='http.cors.allow-origin: "*"'
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="http.cors.enabled: true"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="node.master: true"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="network.host: 0.0.0.0"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
