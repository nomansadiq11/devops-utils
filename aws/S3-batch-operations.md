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
        "ObjectArn": "arn:aws:s3:::s3-inventory-dev/bucket-name/delete-all-object-tags/2023-10-08T01-00Z/manifest.json",
        "ETag": etagvalue
    }
}'

```

```bash

# Replace the placeholder "bucket-name" with the provided manifest bucket name
json_content="${json_content//bucket-name/$manifest_bucket_name}"

# Extract the ETag value from the provided manifest object
etag=$(aws s3api head-object --bucket "s3-inventory-dev" --key "$manifest_bucket_name/delete-all-object-tags/2023-10-08T01-00Z/manifest.json" | jq -r '.ETag')

# Update the JSON content with the extracted ETag value
json_content="${json_content//etagvalue/$etag}"

# Create a new JSON file with the updated content
new_json_file="manifest-$manifest_bucket_name.json"
echo "$json_content" > "$new_json_file"

# Print the path to the new JSON file
echo "manifestfile create : $new_json_file"

bucket_name=$manifest_bucket_name

# Specify the file to save the policy
output_file="$bucket_name-bucket-policy.json"

# Get the bucket policy and save it to the output file
aws s3api get-bucket-policy --bucket "$bucket_name" --query 'Policy' --output text > "policy/$output_file"

# Check if the operation was successful
if [ $? -eq 0 ]; then
    echo "Bucket policy saved to $output_file"
    aws s3api delete-bucket-policy --bucket "$bucket_name"
else
    echo "Failed to retrieve and save the bucket policy"
fi


echo

newjobid=$(aws s3control create-job --account-id "$account_id" --operation file://operation.json --report file://report.json  --manifest file://$new_json_file --priority 10  --role-arn "arn:aws:iam::$account_id:role/s3batchjobrole" --no-confirmation-required)

echo "job is created $newjobid"
job_id=$(echo "$newjobid" | jq -r '.JobId')
echo $job_id >> jobid.log

```
