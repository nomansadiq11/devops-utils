# Forbidden User system:serviceaccount:user:user

## Problem

```text
Error: configmaps "aws-auth" is forbidden: User "system:serviceaccount:user:user" cannot get resource "configmaps" in API group "" in the namespace "kube-system"
```

This could be happen due to manual change from UI in EKS cluster

## how to fix it

```hcl
terragrunt state rm 'kubernetes_config_map.aws_auth[0]'
```

```hcl
terragrunt apply
```

After execuate above command this maybe give error after apply then import again with below command

```hcl
terragrunt import kubernetes_config_map.aws_auth[0] kube-system/aws-auth
```

```hcl
terragrunt apply
```
