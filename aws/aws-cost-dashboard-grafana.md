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
