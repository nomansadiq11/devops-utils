#!/bin/bash

# Specify the folder where the JSON files are located
folder_path="/Users/user/data/"

# Iterate through the JSON files in the folder
for json_file in "$folder_path"/*.json; do
    # Check if the file exists and is a regular file
    if [ -f "$json_file" ]; then

        # Use jq to update the JSON file in place
        jq 'if .["s3.object.tagging"] == "true" then .["s3.object.tagging"] = "false" else . end' "$json_file" > "$json_file.tmp" && mv "$json_file.tmp" "$json_file"
        echo "Updated $json_file"
    fi
done
