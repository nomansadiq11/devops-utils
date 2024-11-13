# Find EC2 Instances with AWS CLI

## Usecase

I have usecase, I need to find the EC2 instances which contains specfic value match, I have created command to get the ec2 instances with contains

> This will find the instances with values contains `prod` all the ip address with comma seprated

```bash

aws ec2 describe-instances \
    --filters "Name=tag-key,Values=Name" \
    --query "Reservations[*].Instances[?contains(Tags[?Key=='Name'].Value | [0], 'prod')].PrivateIpAddress" \
    --output text | tr -s '\t' ',' | tr '\n' ',' | sed 's/,$//'

```

> This will find only those instances which `tag` Name contains `prod` all the ip address with comma seprated

```bash

aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=prod" \
    --query "Reservations[*].Instances[*].PrivateIpAddress" \
    --output text | tr -s '\t' ',' | tr '\n' ',' | sed 's/,$//')

```
