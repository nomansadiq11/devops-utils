# AWS IAM keys exposed

## Usecase

- somehow your AWS access `keys` and secret `keys` exposed to github or somewhere
- AWS will notifiy via email or notification `AWS Health Dashboard`, look for the details and proceed further

## Solution

- Step 1: First identify the applications which uses these keys
- Step 2: Check cloudtrail logs on all the aws regions and try to understand of all those request are for your business
- Step 3: rotate the keys, deactivate the keys and create new keys or create new user and generate new keys
- Step 4: Keep monitoring the resouces maybe thread actor created resouces for crypto mining
