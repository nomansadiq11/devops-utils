# AWS S3 Bucket Inventory

## Usecase

- We need to create S3 inventory to perform bulk operation on S3 objects
- S3 inventory will provide all the objects name and other attributes

> S3 bucket skiplist, if there are any bucket which you want to skip for S3 inventory

```log
2023-02-23 17:28:45 bucketname1
2023-02-22 13:53:17 bucketname2
```

> script to create the S3 bucket inventory

```bash

#!/bin/bash

# Read the skip list from a file
skip_file="skiplist.log"
skip_buckets=()

if [ -f "$skip_file" ]; then
  while read -r line; do
    # Extract the bucket name from each line in the file
    bucket_name=$(echo "$line" | awk '{print $NF}')
    skip_buckets+=("$bucket_name")
  done < "$skip_file"
fi

# Inventory configuration in JSON format (without the bucket placeholder)
inventory_config='
{
  "Destination": {
    "S3BucketDestination": {
      "AccountId": "123456789",
      "Bucket": "arn:aws:s3:::outputbucketname",
      "Format": "CSV"
    }
  },
  "IsEnabled": true,
  "Id": "delete-all-object-tags",
  "IncludedObjectVersions": "Current",
  "OptionalFields": [
    "Size",
    "LastModifiedDate",
    "ETag"
  ],
  "Schedule": {
    "Frequency": "Weekly"
  }
}
'

# List all S3 buckets and capture the bucket names
bucket_list=$(aws s3 ls | awk '{print $3}')

# Loop through the list of bucket names and create inventory configurations
for bucket in $bucket_list; do
  # Check if the bucket is in the list of buckets to skip
  if [[ " ${skip_buckets[@]} " =~ " ${bucket} " ]]; then
    echo "Skipping inventory for |$bucket"
  else
    # Replace the $bucket placeholder with the current bucket name
    bucket_inventory_config="${inventory_config//\$bucket/$bucket}"
    echo "Creating inventory for |$bucket"

    aws s3api put-bucket-inventory-configuration --bucket "$bucket" --id delete-all-object-tags --inventory-configuration "$bucket_inventory_config"
  fi
done


```
