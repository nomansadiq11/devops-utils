# Kubernetes Monitoring Tools

## Kube-Ops-View

Documentations link <https://codeberg.org/hjacobs/kube-ops-view>

```bash
kubectl proxy --accept-hosts '.*' &
docker run -it -p 8080:8080 -e CLUSTERS=http://docker.for.mac.localhost:8001 hjacobs/kube-ops-view
```

## eks-node-viewer

Documentations link <https://github.com/awslabs/eks-node-viewer?tab=readme-ov-file>

```bash
brew tap aws/tap
brew install eks-node-viewer
```
