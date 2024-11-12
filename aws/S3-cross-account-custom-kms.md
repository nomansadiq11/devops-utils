# S3 Cross Account Access with Custom KMS Key

## Usecase

- There are some cases you have used custom `KMS` key to encrypt the data in `S3`. Now there are requirement to share this `S3` bucket with another account.
- Either with `Role` or `User` access keys

## Solution

- Step 1: you need to add permission into `S3` bucket policy for that role
- Step 2: Same role we need to add permission in custom `KMS` provide permission for `encrypt`,`decrypt` or as neccessaary
- Step 3: Add permssion in the role for `S3` access
- Step 4: Add permission in the role for `KMS` arn with require permission like `encrypt`,`decrypt`
