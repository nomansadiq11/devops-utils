# How to automate stop RDS when it's started

## Usecase

I have requirement to stop the RDS instances for couple of days/months but my rds will be stop only for 7 days, after that it will start automatically.

Solution: I need to create a job to stop it whenever it's start, I have created EventBride rule track rds state and send event to SNS and SNS will trigger lambda function to stop the rds instance.

### Step 1

- create Lambda function
- provide appropreiate permission for rds

```python
import boto3

def lambda_handler(event, context):
    client = boto3.client('rds')
    response = client.stop_db_instance(
        DBInstanceIdentifier='infadev'
    )
    return response


```

### Step 2

- create SNS topic
- subscribe lambda function

### Step 3

- create rule in eventbridge with below payload
- set the target for sns topic you created. (You can also set target lambda function directly)

```json
{
  "detail-type": ["RDS DB Instance Event"],
  "source": ["aws.rds"],
  "region": ["eu-west-1"],
  "resources": ["arn:aws:rds:eu-west-1:123456789:db:instancename"],
  "detail": {
    "EventCategories": ["availability"],
    "SourceType": ["DB_INSTANCE"],
    "SourceArn": ["arn:aws:rds:eu-west-1:123456789:db:instancename"],
    "Message": ["DB instance restarted"],
    "SourceIdentifier": ["instancename"],
    "EventID": ["RDS-EVENT-0006"]
  }
}
```
