# AWS S3 bucket cost

## Usecase

- There is requirenment for get each S3 bucket size, below script created to get earch S3 bucket size

> script for get each S3 bucket cost

```bash
for i in $(aws s3 ls| awk '{print $3}'); do
  size=$(aws cloudwatch get-metric-statistics \
    --namespace AWS/S3 --metric-name BucketSizeBytes \
    --dimensions Name=BucketName,Value=$i \
                 Name=StorageType,Value=StandardStorage \
    --start-time 2023-09-24T00:00 --end-time 2023-09-25T00:00 \
    --period 60 --statistic Average | jq -er '.Datapoints[0].Average')
  gb_value=$(echo "scale=2; $size/1000000000" |bc -l)
  echo "Bucket: $i -> size: $gb_value GB"
done
```
