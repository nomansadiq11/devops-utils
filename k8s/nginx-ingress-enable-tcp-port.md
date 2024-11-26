# Nginx Ingress Enable TCP ports

## Usecase

- We have requirment to enable the tcp port nginx
- if you have installed nginx ingress in your kubernetes cluster which support port 80 or 443 which is http(s) ports
- we have usecase to install `sftp` in kubernetes cluster and able to access port `22`

## Solution

- nginx provide option to enable by enable the port only
- update in value file to add tcp port

```yaml

tcp:
  22: "namespace/service-name:port"

```
