# Kafka Connectors Configurations

## Usecase

- there was requirements to update the all the kafka connectors configs, so we created below script todo this change

> get all the connectors config

```bash
#!/bin/bash

# Define the base URL for the connectors
BASE_URL="https://cp-kafka-connect.com/connectors/"

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

```

> Update the change like change the tags

```bash

#!/bin/bash

# Specify the folder where the JSON files are located
folder_path="path for config files"

# Iterate through the JSON files in the folder
for json_file in "$folder_path"/*.json; do
    # Check if the file exists and is a regular file
    if [ -f "$json_file" ]; then

        # Use jq to update the JSON file in place
        jq 'if .["s3.object.tagging"] == "true" then .["s3.object.tagging"] = "false" else . end' "$json_file" > "$json_file.tmp" && mv "$json_file.tmp" "$json_file"
        echo "Updated $json_file"
    fi
done
```

> Update all the configs to connectors

```bash

#!/bin/bash

BASE_URL="https://cp-kafka-connect.come/connectors/"


connector_names=($(curl -s "$BASE_URL" | jq -r '.[]'))

if [ $? -ne 0 ]; then
  echo "Failed to fetch connector names from $BASE_URL"
  exit 1
fi

for connector_name in "${connector_names[@]}"; do
  echo "$connector_name"

  FULL_URL="${BASE_URL}${connector_name}/config"
  FILENAME="${connector_name}.json"

  curl -X PUT -H "Content-Type: application/json" -d @"$FILENAME" "https://cp-kafka-connect.com/connectors/$connector_name/config"

  echo "Config updated for $connector_name and saved as $FILENAME"

done


```
