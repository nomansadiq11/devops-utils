# Kubernetes

## Classic Kubernetes Architecture

<p align="center">
  <img src="img/Kubernetes_Architecture.png">
</p>

### Kubernetes Network

Tim Hockin, one of the lead Kubernetes developers, has created a very useful slide deck to understand the Kubernetes networking: [An Illustrated Guide to Kubernetes Networking ](https://speakerdeck.com/thockin/illustrated-guide-to-kubernetes-networking).

[Cluster Networking Page](https://kubernetes.io/docs/concepts/cluster-administration/networking/)

## Main Deployment Configurations

At a high level, you have four main deployment configurations:

### Single-node
With a single-node deployment, all the components run on the same server. This is great for testing, learning, and developing around Kubernetes.

### Single head node, multiple workers

Adding more workers, a single head node and multiple workers typically will consist of a single node etcd instance running on the head node with the API, the scheduler, and the controller-manager.

### Multiple head nodes with HA, multiple workers

Multiple head nodes in an HA configuration and multiple workers add more durability to the cluster. The API server will be fronted by a load balancer, the scheduler and the controller-manager will elect a leader (which is configured via flags). The etcd setup can still be single node.

### HA etcd, HA head nodes, multiple workers

The most advanced and resilient setup would be an HA etcd cluster, with HA head nodes and multiple workers. Also, etcd would run as a true cluster, which would provide HA and would run on nodes separate from the Kubernetes head nodes.
