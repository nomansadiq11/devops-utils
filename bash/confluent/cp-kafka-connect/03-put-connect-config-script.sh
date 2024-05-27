#!/bin/bash

BASE_URL="https://localhost/connectors/"


connector_names=($(curl -s "$BASE_URL" | jq -r '.[]'))

if [ $? -ne 0 ]; then
  echo "Failed to fetch connector names from $BASE_URL"
  exit 1
fi

for connector_name in "${connector_names[@]}"; do
  echo "$connector_name"

  FULL_URL="${BASE_URL}${connector_name}/config"
  FILENAME="${connector_name}.json"



  curl -X PUT -H "Content-Type: application/json" -d @"$FILENAME" "https://$BASE_URL/connectors/$connector_name/config"

  echo "Config updated for $connector_name and saved as $FILENAME"
done
