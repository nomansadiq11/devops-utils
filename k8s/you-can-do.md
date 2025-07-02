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
# node level
kubectl top nodes

kubectl top nodes --sort-by cpu

kubectl top nodes --sort-by mem

kubectl top nodes -l nodegroup=apps

# pod level

kubectl top pod

kubectl top pod --sort-by cpu

kubectl top pod --sort-by mem

kubectl top pod -l nodegroup=apps

# this will give you resouces usage by containers level

kubectl top pod pod-name --containers

```

> Delete pods forcely

```bash
kubectl delete po {podname} -n namespace --grace-period=0 --force
```

> Create temporary pod and test you command on the kubernetes for like networks

```shell
k -n default run nginx --image=nginx:1.21.5-alpine --restart=Never -i --rm  -- curl app1.app.svc.cluster.local
```

Get All the ingress hosts column

```bash
kubectl get ing -A -o jsonpath="{range .items[*]}{.spec.rules[*].host}{'\n'}{end}"
```
