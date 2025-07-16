# Get CPU Consumption by Container in Grafana Visual

## usecase

We have running application to the kubernetes, we want to understand how much `CPU` consumed by that pod, but the pod can contains the multiple containers which gives more value then actual node size.

So here is promeSQL which give us the exact amount of CPU usage by each container

```promql
sum by (pod, container) (
  rate(container_cpu_usage_seconds_total{namespace="namespace"}[5m])
)
```
