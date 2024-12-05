# SFTPGo

## Usecase

- We got business requirnment to deploy sftp server with backend s3

## Solution

- I found solution to deploy sftpgo in our kubernetes as containers
- I deployed ths and configure the s3 permission to use it
- configure the user with s3 bucket

> sftpgo

```bash
helm repo add sagikazarmark https://charts.sagikazarmark.dev
```

### Takeways

- I found that always use recommanded container image by helm chart
