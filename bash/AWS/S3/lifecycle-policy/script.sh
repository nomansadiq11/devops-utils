#!/bin/bash

# Specify the path to the JSON file containing the lifecycle policy
lifecycle_policy_file="policy.json"

# List all S3 buckets
bucket_names=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

# Iterate through the bucket names
for bucket_name in $bucket_names; do
    echo "getting lifecycle policy for bucket: $bucket_name"

    # Apply the lifecycle policy from the JSON file to the current bucket
    aws s3api put-bucket-lifecycle-configuration --bucket "$bucket_name" --lifecycle-configuration "file://$lifecycle_policy_file"
done
