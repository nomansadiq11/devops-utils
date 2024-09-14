# Kind cli is use for local development for the kubernets

### prerequisite

- docker/containerd
- go

[here is link to install/mac/window/links] (https://kind.sigs.k8s.io/docs/user/quick-start/)

### Use Case

- Test the different versions of Kubernetes apis
- run multiple versions of the Kubernetes


> You can create multi node cluster
```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```