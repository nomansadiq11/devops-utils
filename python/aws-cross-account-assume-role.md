# AWS Cross Account Athena Access via Assume Role

## Usecase

- If there are requirements to access glue database accross different account, you can use this approach as well by assume account B role in Acount A
- let say you are running an application in Account A which has role that can assume the Account B role and run `SQL` queries via athena

```python

import boto3, time

ACCOUNT_A_ROLE_ARN = "arn:aws:iam::[account-id]:role/[role-name]"
region = "eu-west-1"
database = "database_name"
query = 'SELECT * FROM table_name LIMIT 5;'
output_location = "s3://output-bucket/"
sts = boto3.client("sts")
assumed = sts.assume_role(RoleArn=ACCOUNT_A_ROLE_ARN, RoleSessionName="athena-xacct",ExternalId="123456789")

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
