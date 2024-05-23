#!/bin/bash

bucket_names=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

# Iterate through the bucket names
for bucket_name in $bucket_names; do

    echo "Configuring lifecycle policy for bucket: $bucket_name"
    aws s3api delete-bucket-inventory-configuration --bucket $bucket_name --id delete-all-object-tags

done
