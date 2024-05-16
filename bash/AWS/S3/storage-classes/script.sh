#!/bin/bash

# Specify the file containing the list of S3 object URLs
# List all the urls of the object in the files by using the S3 inventory
input_file="s3biggerobjectscopy.txt"

# Iterate through each line in the file
while IFS= read -r s3_object_url; do

    s3_path=$(dirname "$s3_object_url")

    object_name=$(basename "$s3_object_url")

    echo "Copying ========================================="
    echo "$s3_object_url"
    # aws s3 cp "$s3_object_url" "$s3_path/" --storage-class INTELLIGENT_TIERING --profile maf-analytics
    aws s3 cp "$s3_object_url" "$s3_path/" --storage-class INTELLIGENT_TIERING
    echo "end copying  ========================================="



    # Print a message indicating the copy operation for each object
    echo "Copied $s3_object_url to $s3_path"

done < "$input_file"
