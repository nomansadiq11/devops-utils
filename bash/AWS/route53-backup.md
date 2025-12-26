# How we can take backup of Route53

## Usecase

- Before deleting the route53 zone take backup then delete it

Script

```sh
#!/bin/bash

mkdir -p route53-backups

for zone in $(aws route53 list-hosted-zones --query "HostedZones[].Id" --output text); do
  ZONE_ID=$(basename $zone)
  ZONE_NAME=$(aws route53 get-hosted-zone --id $ZONE_ID --query "HostedZone.Name" --output text | sed 's/\.$//')

  aws route53 list-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --output json > route53-backups/${ZONE_NAME}.json

  echo "Backed up $ZONE_NAME"
done

```
