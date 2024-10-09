# AWS S3 Delete non-current version

one of the reason your AWS S3 cost can increase if you enable the object versioning

## Usecase

- our S3 cost getting increase so we analyse it with S3 dashboard and found that there are millions of objects which is non-current version
- we each S3 bucket we added S3 lifecycle policy to delete all the non-current version
- this is becuase we didn't want non-current version object but some cases you need it as object backup

### Importanct Note

- Adding policy from cli will overwrite all your existing policy
- first import all the existing policies in json format
- if you many buckets you can get json policy first and modify and update it.

> how I added all the s3 bucket same policy

```bash
#!/bin/bash

# Specify the path to the JSON file containing the lifecycle policy
lifecycle_policy_file="policy.json"

# List all S3 buckets
bucket_names=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

# Iterate through the bucket names
for bucket_name in $bucket_names; do
    echo "Configuring lifecycle policy for bucket: $bucket_name"

    # Apply the lifecycle policy from the JSON file to the current bucket
    aws s3api put-bucket-lifecycle-configuration --bucket "$bucket_name" --lifecycle-configuration "file://$lifecycle_policy_file"
done

```

> policy

```json
{
  "Rules": [
    {
      "ID" : "delete-NoncurrentVersion-and-incomple-multipart",
      "Status": "Enabled",
      "Prefix": "",
      "NoncurrentVersionExpiration": {
        "NoncurrentDays": 1
      },
      "AbortIncompleteMultipartUpload": {
        "DaysAfterInitiation": 1
      }
    }
  ]
}

```
