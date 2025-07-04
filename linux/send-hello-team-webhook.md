# Send Hello to Microsoft Teams Webhook

## Usecase

I need to test teams webhook api to make sure it's receive the alerts, so simple we can do by using the curl command

using `curl` command we can send messages teams webhook url

```bash
curl -H "Content-Type: application/json" \
     -d '{"text": "Hello from curl!"}' \
     https://outlook.office.com/webhook/YOUR_WEBHOOK_URL

```
