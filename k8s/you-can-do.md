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

```shell
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
```

> Get all the running pods sort by asc

```shell
kubectl get pods --sort-by=.metadata.creationTimestamp  --field-selector=status.phase=Running
```

> delete bulk pods

```shell
kubectl get pod -n namespace --field-selector=status.phase==Failed -o jsonpath='{}' | jq -r ".items[] | .metadata.name" | xargs --no-run-if-empty kubectl -n namespace delete pod

```

> Install metrics server and use following to understand the `CPU` and `MEM` usage

```bash
#
kubectl top nodes

kubectl top nodes --sort-by cpu

kubectl top nodes --sort-by mem

kubectl top nodes -l nodegroup=apps

```
