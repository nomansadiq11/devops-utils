# Kindcli

This use for locally kubernetes application development or kubernetes cluster management

## prerequisite

- docker/containerd
- go
- install kindcli [install](https://kind.sigs.k8s.io/docs/user/quick-start/)

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

> create kubernetes cluster with specific version

```shell
kind create cluster --config kind-multi-node.yaml --image=kindest/node:v1.30.0
```
