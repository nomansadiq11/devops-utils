# AWS EC2 Instance Start Stop

## Usecase

- There could be development EC2 instances which needs to run only during working hours
- So we created bash script to run cron job and start and stop the ec2 instance to save the cost
- you can run this as kubernetes cronjob as well.

> script

```bash
#!/bin/bash -x

# Function to assume a role
assume_role() {
    local aws_profile="$1"
    local role_arn="$2"
    local session_name="$3"

    aws sts assume-role --profile "$aws_profile" --role-arn "$role_arn" --role-session-name "$session_name" > assume_role.json
    export AWS_ACCESS_KEY_ID=$(jq -r .Credentials.AccessKeyId assume_role.json)
    export AWS_SECRET_ACCESS_KEY=$(jq -r .Credentials.SecretAccessKey assume_role.json)
    export AWS_SESSION_TOKEN=$(jq -r .Credentials.SessionToken assume_role.json)
}

# Check for the correct number of command-line arguments
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <isassumerole> <instanceid> <assumerole> <start/stop>"
    exit 1
fi

is_assume_role="$1"
instance_id="$2"
assume_role="$3"
action="$4"  # Specify "start" or "stop"

# Check if we should assume a role
if [[ "$is_assume_role" == "true" ]]; then
    aws_profile="your-aws-profile"  # Your AWS CLI profile for assuming roles
    role_arn="arn:aws:iam::123456789:role/$assume_role"  # ARN of the role
    session_name="AssumeRoleSession"

    # Assume the role and obtain temporary credentials
    assume_role "$aws_profile" "$role_arn" "$session_name"
fi

# Start or stop the instance based on configuration
if [[ "$action" == "start" ]]; then
    echo "Starting instance $instance_id ..."
    aws ec2 start-instances --instance-ids "$instance_id"
elif [[ "$action" == "stop" ]]; then
    echo "Stopping instance $instance_id ..."
    aws ec2 stop-instances --instance-ids "$instance_id"
else
    echo "Invalid action. Specify 'start' or 'stop'."
    exit 1
fi

```
