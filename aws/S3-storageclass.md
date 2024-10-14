# AWS S3 Storage Class

## Usecase

- There are object which is bigger than 5GG
- you need to move different storage class like below script I am moving it INTELLIGENT_TIERING
- you cannot do using S3 bulk operations, you need to move manullay either from AWS Console or using some kind of script

> script for move objects to different storage class

```bash
#!/bin/bash

# Specify the file containing the list of S3 object URLs
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

```
