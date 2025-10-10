# Add Security Group rules

```bash
# Define variables
SG_ID="adfasdfa"
SOURCE_IP="0.0.0.0/0"
PORTS=(1433)
DESCRIPTION="access provide "

# Build JSON dynamically and run the command

aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" \
  --ip-permissions "$(
    jq -nc \
      --arg ip "$SOURCE_IP" \
      --arg desc "$DESCRIPTION" \
      --argjson ports "$(printf '%s\n' "${PORTS[@]}" | jq -R 'tonumber' | jq -s .)" '
      [$ports[] | {
        IpProtocol: "tcp",
        FromPort: .,
        ToPort: .,
        IpRanges: [{CidrIp: $ip, Description: $desc}]
      }]
    '
  )"
```
