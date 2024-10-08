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
