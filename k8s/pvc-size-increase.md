# How to increase PVC (Persistent Volumes Claim) size

## Usecase

- Pod is failing to start due to disk full, in that base we need to increase the pvc size

## Solution

First we need to make sure our storageclass support to allow extend the disk. Find your storageclass and add the below property to allow extend the volume.

```yaml
allowVolumeExpansion: true
```

Run the following command to extend the `PVC`size to `50Gi`

```bash
kubectl patch pvc <pvc-name> -n <namespace> -p '{"spec": {"resources": {"requests": {"storage": "50Gi"}}}}'
```

Check the `PVC`

```bash
kubectl get pvc -n <namespace>
```
