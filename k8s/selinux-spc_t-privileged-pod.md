# Running an Unconfined (Privileged SELinux) Pod using `spc_t`

Making a Kubernetes Pod SELinux-Unconfined via `seLinuxOptions.type: spc_t`

## 2. Problem

On **Bottlerocket** nodes, SELinux is enforced by default. Every pod is assigned:

- An SELinux **type** — normally `container_t` (confined).
- A random per-pod **MCS category pair** — e.g. `s0:c123,c456` — generated fresh each time the pod is scheduled.

Files/directories on a mounted volume are also labeled with a specific SELinux type
and category (e.g. `system_u:object_r:data_t:s0:c123,c456`).

**Access is only allowed when the pod's SELinux category matches the label already on disk.** If they don't match — which happens whenever

- the volume was written by an older pod instance with a different random category,
- the volume was created/labeled before SELinux was enforced (e.g. pre-Bottlerocket
  nodes), or
- the CSI driver / kubelet failed to relabel the volume on mount (a known gap with
  some CSI drivers, including the AWS EBS CSI driver in some configurations)

...the container gets:

```bash
EACCES: permission denied
```

even though normal Unix file permissions (`ls -l`) look completely fine.

**Important limitation discovered:** you **cannot** fix this by running the container as `privileged: true` and `root`. Bottlerocket reserves the SELinux `relabelto` / `relabelfrom` permissions for the **host container runtime only** — not for any workload container, privileged or not. So `chcon`/`restorecon` run from *inside* a pod will always fail with `Permission denied`, regardless of user or capabilities.

## 3. Solution

Set the pod's SELinux type to **`spc_t`** ("super privileged container") in the pod's `securityContext`. This is a special, pre-defined SELinux type that runs **unconfined** — i.e. all SELinux type/category enforcement is bypassed for that pod, so it can read/write any file regardless of its on-disk SELinux label.

This does **not** fix the underlying mislabeled data — it makes the pod immune to the mismatch by no longer being subject to SELinux checks at all.

### Raw Kubernetes YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-workspace
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: example-workspace
  template:
    metadata:
      labels:
        app: example-workspace
    spec:
      # --- Pod-level securityContext ---
      securityContext:
        runAsUser: 1000
        runAsNonRoot: false
        fsGroup: 1000
        seLinuxOptions:
          type: spc_t          # <-- unconfined SELinux type; bypasses SELinux checks
      containers:
        - name: main
          image: my-workspace-image:latest
          volumeMounts:
            - name: home
              mountPath: /home/coder
      volumes:
        - name: home
          persistentVolumeClaim:
            claimName: example-workspace-home
```

> **Note:** Add `se_linux_options` to the pod-level `security_context` block
> (applies to all containers in the pod), not a container-level `security_context`
> block, unless you only want a specific container unconfined.

### Verifying it worked

```bash
# 1. Check the Pod's securityContext has seLinuxOptions.type = spc_t
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.securityContext}'

# 2. Check the actual running process's SELinux context (should show an
#    unconfined-family type such as control_t/spc_t, NOT container_t)
kubectl exec -n <namespace> <pod-name> -c <container> -- cat /proc/1/attr/current

# 3. Confirm the previously-failing file is now accessible
kubectl exec -n <namespace> <pod-name> -c <container> -- cat /path/to/previously-failing-file
```

---

## 4. Pros and Cons

### ✅ Pros

- **Immediate fix** — resolves `EACCES` errors instantly, no data migration or relabeling required.
- **No downtime for the fix itself** — if resource types are *not* renamed in the same change (see caution below), applying this is a simple in-place pod spec update; Kubernetes just does a rolling pod replacement.
- **Safe to apply broadly** — works for any workspace/pod regardless of what's already on its volume; doesn't require knowing which files are mislabeled.
- **No dependency on infrastructure upgrades** — doesn't require upgrading the EBS CSI driver, enabling K8s feature gates, or coordinating a cluster-wide change.

### ⚠️ Cons

- **Weakens SELinux isolation** — `spc_t` pods are completely unconfined by
  SELinux, meaning SELinux no longer provides any additional containment for
  that pod beyond standard Linux namespaces/cgroups. If SELinux was relied upon
  as a defense-in-depth layer (e.g. against container breakout via kernel
  exploits), that layer is removed for these pods.
- **Doesn't fix root cause** — the underlying data on disk remains mislabeled
  (`data_t` instead of the correct type). If you ever remove `spc_t` later,
  the original `EACCES` errors will return.
- **Applies per-pod, not per-cluster** — every template/deployment that needs
  this must be updated individually; it's not a one-time cluster-wide fix.
- **Easy to conflate with unrelated template changes** — as seen in this
  incident, this SELinux fix got bundled with a Terraform resource-type
  rename (`kubernetes_deployment` → `kubernetes_deployment_v1`), which is a
  **completely separate, much riskier change** (see below). Keep the two
  changes isolated.

---

## 5. Critical Caution — Don't Bundle With Resource Type Renames

If your Terraform template also renames resource types (e.g.
`kubernetes_deployment` → `kubernetes_deployment_v1`,
`kubernetes_service` → `kubernetes_service_v1`,
`kubernetes_persistent_volume_claim` → `kubernetes_persistent_volume_claim_v1`)
in the **same change** as adding `spc_t`:

- Terraform treats this as a **different resource type**, not a rename.
- For **existing** workspaces (with prior state), Terraform will plan to
  **destroy the old object and create a brand-new one** — including PVCs,
  which can mean **data loss** unless your StorageClass has
  `reclaimPolicy: Retain`.
- Terraform `moved` blocks **cannot** bridge this — they only work for
  same-type renames/reindexing, and will fail with
  `Error: Resource type mismatch` if you try.
- **New** workspaces (no prior state) are unaffected either way, since
  there's nothing to reconcile.

**Recommendation:** Add the `spc_t` fix to your **existing, unchanged resource
type names**. Don't rename resource types in the same template push.

---

## 6. Quick Recovery (if a PVC was accidentally destroyed)

Only possible if the StorageClass has `reclaimPolicy: Retain`:

```bash
# 1. Confirm the old PV is now "Released" (not deleted)
kubectl get pv | grep <old-pvc-name>

# 2. Clear the stale claimRef so it can rebind to a new PVC of the same name
kubectl patch pv <pv-name> --type=merge -p \
  '{"spec":{"claimRef":{"uid":null,"resourceVersion":null}}}'

# 3. Confirm it's now "Available"
kubectl get pv <pv-name>

# 4. Re-run the workspace build/apply — it will bind to this same PV,
#    preserving all original data.
```
