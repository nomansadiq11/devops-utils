# EKS Audit Logs via CloudWatch

## Usecase

There were some jobs which getting killed and we need to find out who killed it, so here it come use `Kubernetes` Audit logs to find out. I have enabled the EKS logs to cloudwatch then I am able to write the following query to get the output

```QL
fields @timestamp, user.username, userAgent, sourceIPs, responseStatus.code, objectRef.name
| filter verb = "delete"
| filter objectRef.resource = "pods"
| filter objectRef.name = "podname"
| sort @timestamp desc
```
