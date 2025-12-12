# Lambda environment variables update

## usecase

- sometime we need to update many lambda function enviroment variables, so here I have created a script which will help to update variables

Existing function name should be in file

```txt
lambda1
lambda2
lambda3
```

```bash
#!/bin/bash

key=$1
value=$2

while read fn; do
  echo "Updating $fn ..."

  # Get existing variables as JSON
  vars=$(aws lambda get-function-configuration \
    --function-name "$fn" \
    --query "Environment.Variables" \
    --output json)

  # Merge with your new variable
  new_vars_json=$(echo "$vars" | jq --arg k "$key" --arg v "$value" '. + {($k): $v}')

  # Convert JSON to AWS CLI variable format: KEY=value,KEY2=value2
  new_vars_cli=$(echo "$new_vars_json" | jq -r 'to_entries | map("\(.key)=\(.value)") | join(",")')

  # Update Lambda
  aws lambda update-function-configuration \
    --function-name "$fn" \
    --environment "Variables={$new_vars_cli}"

done < lambdas.txt

echo "Done."

```
