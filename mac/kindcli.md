# Kind cli is use for local development for the kubernets

## prerequisite

- docker/containerd
- go

> install kindcli [install](https://kind.sigs.k8s.io/docs/user/quick-start/)

## Use Case

- Test the different versions of Kubernetes apis
- run multiple versions of the Kubernetes
- you can create multiple node workers cluster

> how to create multiple node wokers cluster
> use below yaml file

```shell
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```

```shell
kind create cluster --name kubecluster1 --config kind-multi-node.yaml
```
