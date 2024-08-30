# kubectl commands

## description

these are commands useful for kubernetes, sometimes you need to review the commands

> you can restart the deployment

```shell
kubectl rollout restart deployment {deployment-name}
```

> you can scale the deployment or replicaset

```shell
kubectl scale deployment {deployment-name} --replicas=2
```

> you can get the nodes by using the lables with instance type

```shell
 kubectl get no -L nodegroup,beta.kubernetes.io/instance-type --sort-by='.metadata.labels.nodegroup'
```
