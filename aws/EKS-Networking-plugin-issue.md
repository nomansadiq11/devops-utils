# EKS Cluster Health Error - VPC Plugin failed to provide more IPs

## Usecase

- Control Plane unable to provide new IPs to new pods due to all the IPs are consumed
- All the IPs are consumed by pods and each ENI have multiple secondary IPs

## Solution

If we enable `WARM_IP_TARGET=0` or `WARM_IP_TARGET=1` which will be keep only 1 IP reserve and release the other IPs from ENI

how todo this

```sh
kubectl set env daemonset aws-node -n kube-system WARM_IP_TARGET=1
```

restart the aws-node

```sh
kubectl rollout restart daemonset aws-node -n kube-system
```
