# AWS S3 Batch Operations

```bash
#!/bin/bash

# Check if the script is called with an argument
if [ $# -ne 2 ]; then
  echo "Usage: $0 <manifest-bucket-name>"
  exit 1
fi

# Get the manifest bucket name from the script argument
manifest_bucket_name="$1"
account_id="$2"

echo "Creating job for account id $2 and bucket $1"

# Define the JSON content with placeholders
json_content='{
    "Spec": {
        "Format" : "S3InventoryReport_CSV_20161130"
    },
    "Location": {
        "ObjectArn": "arn:aws:s3:::s3-inventory-grid2-dev/bucket-name/delete-all-object-tags/2023-10-08T01-00Z/manifest.json",
        "ETag": etagvalue
    }
}'

```
