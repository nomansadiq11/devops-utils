# AWS Delete S3 objects

## Usecase

- You can empty the S3 bucket by using AWS console but if there are more than 1 AWS accounts and clean those bucket
- by using different IAM role or keys using same script to clean it.

```bash
#!/bin/bash

bucket=aws-cost-bi-dev


echo "Start deleting files...."
aws s3 rm s3://$bucket --recursive
echo "End deleting files...."

# disable teh S3 bucket version
aws s3api put-bucket-versioning --bucket $bucket --versioning-configuration Status=Suspended

```
