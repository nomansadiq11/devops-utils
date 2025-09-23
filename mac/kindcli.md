# Kindcli

This use for locally kubernetes application development or kubernetes cluster management

## Prerequisite

- docker/containerd
- go
- install kindcli [install](https://kind.sigs.k8s.io/docs/user/quick-start/)

## Usecase

- Test the different versions of Kubernetes apis
- run multiple versions of the Kubernetes
- you can create multiple node workers cluster

Create cluster with multiple worker nodes

```yaml
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

create kubernetes cluster with specific version

```shell
kind create cluster --config kind-multi-node.yaml --image=kindest/node:v1.30.0
```

Create cluster without `Network Plugin`

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
networking:
  disableDefaultCNI: true
```
