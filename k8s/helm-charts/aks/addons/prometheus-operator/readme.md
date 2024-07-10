
# Prometheus Operator for Kubernetes

helm link

```shell
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
```

add helm repo

```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

install helm

```shell
helm install [RELEASE_NAME] prometheus-community/kube-prometheus-stack
```
