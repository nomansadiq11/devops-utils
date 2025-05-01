# How to expose your S3 Static Website via CloudFront

## Usecase

- We need to expose our application publically with quick and easy way with less amount of money.

## Solution

- You need S3 bucket to place your website files in it.
- You need CloudFront `distribution` which will point to your S3 bucket

S3 bucket permission, add your accountID and CloudFront distributions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontAccessOnly",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-image-bucket/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::YOUR_ACCOUNT_ID:distribution/YOUR_DISTRIBUTION_ID"
        }
      }
    }
  ]
}


```
