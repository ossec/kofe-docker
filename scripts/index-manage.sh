#!/bin/bash

CURL=`which curl`

read -p "Enter Elasticsearch Password: " pass


response=$($CURL --write-out "%{http_code}\n" --silent --output /dev/null -XPOST 'http://localhost:5601/api/saved_objects/index-pattern' \
                -H 'Content-Type: application/json' \
                -H 'kbn-version: 7.12.0' \
                -u elastic:${pass} \
                -d '{"attributes":{"title":"ossec-*","timeFieldName":"@timestamp"}}')


if [ "$response" == "200" ]; then 
   echo "OSSEC index generated!"
   echo 
else 
   echo "Error generating OSSEC index."
   $CURL -XPOST -D- 'http://localhost:5601/api/saved_objects/index-pattern' \
                -H 'Content-Type: application/json' \
                -H 'kbn-version: 7.12.0' \
                -u elastic:${pass} \
                -d '{"attributes":{"title":"ossec-*","timeFieldName":"@timestamp"}}'
fi 
