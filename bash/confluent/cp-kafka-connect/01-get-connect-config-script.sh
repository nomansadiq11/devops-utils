#!/bin/bash

# Define the base URL for the connectors
BASE_URL="https://localhost/connectors/"

# Fetch the array of connector names from the URL and use jq to parse it
connector_names=$(curl -s "$BASE_URL" | jq -r '.[]')

# Check if the request was successful
if [ $? -ne 0 ]; then
  echo "Failed to fetch connector names from $BASE_URL"
  exit 1
fi

# Iterate through the array of connector names
for connector_name in ${connector_names[@]}; do
    echo $connector_name
  # Construct the full URL for the config endpoint
  FULL_URL="${BASE_URL}${connector_name}/config"

  # Generate a filename based on the connector name
  FILENAME="${connector_name}.json"

  # Make the curl request and save the JSON response to the file
  curl -s "$FULL_URL" -o "$FILENAME"

  # Optionally, you can print a message indicating the download status
  echo "Downloaded config for $connector_name and saved as $FILENAME"
done
