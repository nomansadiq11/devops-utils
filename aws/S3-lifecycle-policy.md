
# Add LifeCycle Policy

- S3 bucket add lifecycle policy to all the buckets


## UseCase 1

- let suppose you have so many buckets and you want to remove the data from buckets
- you can add lifecycle policy to delete the data base on the policy 


## Usecase 2

- if you want to move the data to other storage class
- you can also use lifecycle to move the data


```json
{
    "Rules": [
        {
            "Expiration": {
                "Days": 30
            },
            "ID": "delete-after-a-month",
            "Status": "Enabled",
            "NoncurrentVersionExpiration": {
                "NoncurrentDays": 1
            }
        },
        {
            "ID": "delete-marker-after-month",
            "Status": "Enabled",
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

```bash
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

```