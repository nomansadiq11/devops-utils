# POD Toleration and Affinity

## Usecase

- A pods replicasset of 2 schedule on two different nodes
- Both pods shouldn't come to same node
- schedule only to specfic node group

## Solution

We have to configure the nodes taint and the node had some labels like `kubernetes.io/os=linux` and pod have some label like `application=name`

```shell

kubectl taint node test-control-plane app=test:NoSchedule

```

Now configure the pod

```yaml

apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  tolerations:
  - effect: NoSchedule
    key: app
    value: test
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/os
            operator: In
            values:
            - linux
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - ingress-nginx
          topologyKey: kubernetes.io/hostname
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent

```

This yaml have three important sections

### Section 1

pod will schedule only these node which taint like below `app:test:NoSchedule`

```yaml
tolerations:
  - effect: NoSchedule
    key: app
    value: test
```

### Section 2

Pods will schedule only these nodes which ave label `kubernetes.io/os=liniux`

```yaml
nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
    - matchExpressions:
      - key: kubernetes.io/os
        operator: In
        values:
        - linux
```

### Section 3

Pods will not schedule on same node becuase it has `podAntiAffinity` and the follow match label `application=name` and important part is `topologyKey` `kubernetes.io/hostname`

```yaml
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: application
              operator: In
              values:
                - name
        topologyKey: kubernetes.io/hostname


```
