# Glue Database Cross Account Access

## Usecase

I have to access `Glue` database cross account access.

## Solution

There are many ways to achieve it like:

- Provide `Glue` database to cross account access
- Create `IAM` role in Account A and provide Account B to assume this role
- Create data source in athena

### Simple and easy solution to allow cross account users to assume the role

Account B (where you will going to assume the Account A role )

```json
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Principal":{"AWS":"arn:aws:iam::ACCOUNT_B_ID:role/RunnerRole"},
      "Action":"sts:AssumeRole"
    }
  ]
}

```

Account A, create role and attache the policy

```json
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AllowAthenaResultsWrite",
      "Effect":"Allow",
      "Principal":{
        "AWS":"arn:aws:iam::ACCOUNT_A:role/ROL_NAME"
      },
      "Action":[ "s3:PutObject","s3:GetObject","s3:ListBucket" ],
      "Resource":[
        "arn:aws:s3:::BUCKET_NAME",
        "arn:aws:s3:::BUCKET_NAME/output/*"
      ]
    }
  ]
}
```

```python

import boto3, time

# ACCOUNT A ROLE FOR ASSUME
ACCOUNT_A_ROLE_ARN = "ACCOUNT_A"
region = "US-EAST-1"
database = "DATABASE_NAME"
query = 'SELECT * FROM TABLE_NAME LIMIT 5;'
output_location = "s3://BUCKET_NAME/output/"
sts = boto3.client("sts")
assumed = sts.assume_role(RoleArn=ACCOUNT_A_ROLE_ARN, RoleSessionName="athena-xacct")

creds = assumed["Credentials"]

athena = boto3.client(
    "athena",
    region_name=region,
    aws_access_key_id=creds["AccessKeyId"],
    aws_secret_access_key=creds["SecretAccessKey"],
    aws_session_token=creds["SessionToken"],
)

resp = athena.start_query_execution(
    QueryString=query,
    QueryExecutionContext={"Database": database, "Catalog": "AwsDataCatalog"},
    ResultConfiguration={"OutputLocation": output_location},
)

qid = resp["QueryExecutionId"]
print("Started:", qid)

while True:
    info = athena.get_query_execution(QueryExecutionId=qid)
    status = info["QueryExecution"]["Status"]
    state = status["State"]
    if state in ("SUCCEEDED","FAILED","CANCELLED"):
        break
    time.sleep(2)

if state == "SUCCEEDED":
    rows = athena.get_query_results(QueryExecutionId=qid)["ResultSet"]["Rows"]
    for r in rows:
        print([c.get("VarCharValue","") for c in r["Data"]])
else:
    print("Failed:", status.get("StateChangeReason"))
```
