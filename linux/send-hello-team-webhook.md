# Send Hello to Microsoft Teams Webhook

## Usecase

I need to test teams webhook api to make sure it's receive the alerts, so simple we can do by using the curl command

using `curl` command we can send messages teams webhook url

```bash
curl -H "Content-Type: application/json" \
     -d '{"text": "Hello from curl!"}' \
     https://outlook.office.com/webhook/YOUR_WEBHOOK_URL

```

or use this

```bash
curl -H "Content-Type: application/json" \
     -d '{
           "@type": "MessageCard",
           "@context": "http://schema.org/extensions",
           "summary": "Build Notification",
           "themeColor": "0076D7",
           "title": "Build Successful",
           "sections": [{
               "activityTitle": "CI/CD Pipeline",
               "activitySubtitle": "Build #42 completed",
               "text": "The latest build was successful and deployed to staging."
           }]
         }' \
     https://outlook.office.com/webhook/YOUR_WEBHOOK_URL

```
