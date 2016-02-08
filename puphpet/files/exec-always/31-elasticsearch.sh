#!/bin/sh
FILE=/etc/elasticsearch/es-01/elasticsearch.yml

LINE="network.bind_host: 0"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="http.port: 9200"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="http.cors.enabled : true"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="http.cors.allow-methods : OPTIONS, HEAD, GET, POST, PUT, DELETE"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="http.cors.allow-headers : X-Requested-With,X-Auth-Token,Content-Type, Content-Length"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="http.cors.allow-origin : '*'"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

