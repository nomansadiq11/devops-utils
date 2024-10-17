# AWS Cost Dashboard in Grafana

## Usecase

- There are multiple aws accounts, 1 master account and other child accounts, so master account can only view all the other accounts consolidated cost report
- Everyone doesn't have master account access so they can't view all the accounts reports and numbers.
- like there are 200 accounts managed by different teams and they wanted to manage their cost reports in single view

### Solution 1

- Create grafana dashboard top on CUR report
- you need to create each account CUR report and push data to centralized place S3
- create ahtena table and use Athena as datasource in grafana and create the cost dashboard

### Solution 2

- Extract the number of accounts data from master account a child account S3 bucket
- follow solution 1, like Create Athena datasource in grafana and create the dashboard

> Get cost details from cost and usage report

```bash
#!/bin/bash

# Specify the AWS CLI command to retrieve cost data for July and August
aws_command="aws ce get-cost-and-usage --time-period Start=2023-07-01,End=2023-08-31 --granularity MONTHLY --metrics UnblendedCost --output json"

# Execute the AWS CLI command and store the output in a variable
cost_data=$(eval $aws_command)
echo $cost_data

# Use jq to format the JSON data into a table
formatted_data=$(echo $cost_data | jq -r '.ResultsByTime[] | [.TimePeriod.Start, .Metrics.UnblendedCost.Amount] | @tsv')
echo $formatted_data

# Print the formatted data as a table
echo -e "Month\tUnblendedCost"
echo -e "$formatted_data"

```

> cleanup aws cost and usage report from all the accounts

```bash
#!/bin/bash

coststack=aws-cost-stack
bucket=aws-cost
# aws s3api put-bucket-versioning --bucket $bucket --versioning-configuration Status=Suspended
account=1232345677

echo "Removing cost report"
aws cur --region us-east-1 delete-report-definition --report-name "$bucket"

echo "checking status"
aws cloudformation delete-stack --stack-name $coststack
stackstatus=$(aws cloudformation describe-stacks --stack-name $coststack | jq -er '.Stacks[].StackStatus')
echo $stackstatus

while [ "$stackstatus" == "DELETE_IN_PROGRESS" ]
    do
        echo "sleeping still in progress..."
        sleep 1
        stackstatus=$(aws cloudformation describe-stacks --stack-name $coststack | jq -er '.Stacks[].StackStatus')
        echo $stackstatus
    done

echo "DONE stack delete"


echo "Start deleting files...."
aws s3 rm s3://$bucket --recursive
echo "End deleting files...."

echo "Start deleting bucket"
aws s3api delete-bucket --bucket $bucket --region eu-west-1 --output json
echo "bucket is deleted successfully"

echo "deattach policy... "
aws iam detach-role-policy --role-name grafana-athena-datasource-role --policy-arn arn:aws:iam::$account:policy/grafana-athena-datasource
aws iam detach-role-policy --role-name grafana-athena-datasource-role --policy-arn arn:aws:iam::aws:policy/service-role/AmazonGrafanaAthenaAccess

echo "removing the role and policy "
aws iam delete-policy --policy-arn arn:aws:iam::$account:policy/grafana-athena-datasource
aws iam delete-role --role-name grafana-athena-datasource-role


```
