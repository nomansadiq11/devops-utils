# AWS S3 bucket add Name tag

## Usecase

- we have alot of buckets which doesn't have Name tag
- why we need Name tag because we enable in costing to show cost of each resouces tag by name
- so this will help us to find out each bucket cost

> script for adding tag to S3 buckets

```bash
#!/bin/bash

# List all S3 buckets and capture the bucket names
bucket_list=$(aws s3 ls | awk '{print $3}')

# Iterate through the list of bucket names
for bucket in $bucket_list; do
  # Check if the bucket has the "Name" tag already
  existing_name_tag=$(aws s3api get-bucket-tagging --bucket "$bucket" --query "TagSet[?Key=='Name'].Value" --output text)

  if [ -z "$existing_name_tag" ]; then
    # If the "Name" tag doesn't exist, add it with the bucket name as the value
    aws s3api put-bucket-tagging --bucket "$bucket" --tagging 'TagSet=[{Key=Name,Value='"$bucket"'}]'
    echo "Added 'Name' tag to $bucket"
  else
    echo "Skipping $bucket. 'Name' tag already exists with value: $existing_name_tag"
  fi
done

```
