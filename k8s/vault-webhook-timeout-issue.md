# Vault Webhook Timeout Issue

## Uasecase

- We are facing issue for injecting the vault container in the pods
- it was not injecting due to timeout in the webhook

## Solution

- We change timeout in mutationwebhookconfiguration which resolve this issue
- This seems to be temp solution
- We need to find where exactly taking

### Complex Processing

- The Vault webhook might interact with external systems, such as querying Vault servers or validating credentials and configurations.
- If there is latency in the Vault server response, it delays the webhook.

### Large AdmissionReview Payloads

- For complex pod specs (e.g., Grafana with multiple containers or configurations), the AdmissionReview payload sent to the webhook is larger and takes more time to process.

### Network Latency

- Communication between the webhook and the Vault server might experience delays due to transient network issues or high network traffic.

### High Resource Utilization

- The node running the webhook might be under high CPU or memory usage, slowing down the webhook’s processing speed.

### Cluster Scale

- If the cluster has many admission webhooks or is handling numerous requests simultaneously, the webhook processing queue might get delayed.
