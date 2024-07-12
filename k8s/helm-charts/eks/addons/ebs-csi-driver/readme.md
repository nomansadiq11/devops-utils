
# EBS CSI Driver

helm link

```shell
https://github.com/kubernetes-sigs/aws-ebs-csi-driver
```

add helm repo

```shell
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver/
helm repo update
```

install helm

```shell
helm install my-aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver --version 2.32.0
```
