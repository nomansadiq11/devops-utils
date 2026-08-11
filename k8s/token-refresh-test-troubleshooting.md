# Service Account Token Refresh Troubleshooting

This runbook explains how to test service account token validity and rotation using a generic manifest in the `default` namespace.

It helps verify:

1. How long a pod-mounted service account token remains valid.
1. Whether the token file is rotated on disk.
1. Whether your application continues authenticating to the Kubernetes API after rotation.

## Embedded Test Manifest (Generic)

Use this YAML directly from this document:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
   name: token-refresh-test
   namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
   name: token-refresh-test
   namespace: default
rules:
   - apiGroups: [""]
      resources: ["pods"]
      verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
   name: token-refresh-test
   namespace: default
subjects:
   - kind: ServiceAccount
      name: token-refresh-test
      namespace: default
roleRef:
   kind: Role
   name: token-refresh-test
   apiGroup: rbac.authorization.k8s.io
---
apiVersion: v1
kind: Pod
metadata:
   name: token-refresh-test
   namespace: default
spec:
   serviceAccountName: token-refresh-test
   restartPolicy: Never
   automountServiceAccountToken: false
   containers:
      - name: test
         # Replace with an image that has python3 and kubernetes client installed.
         image: your-image-with-python-and-kubernetes-client:latest
         command: ["/bin/bash", "-c"]
         args:
            - |
               echo "=== token rotation proof ==="
               python3 - <<'PY'
               import time, datetime, hashlib, base64, json
               from kubernetes import client, config

               TOKEN_PATH = "/var/run/secrets/kubernetes.io/serviceaccount/token"
               NAMESPACE_PATH = "/var/run/secrets/kubernetes.io/serviceaccount/namespace"

               def token_fingerprint():
                     with open(TOKEN_PATH) as f:
                           tok = f.read()
                     h = hashlib.sha256(tok.encode()).hexdigest()[:12]
                     try:
                           payload = tok.split(".")[1]
                           payload += "=" * (-len(payload) % 4)
                           exp = json.loads(base64.urlsafe_b64decode(payload)).get("exp")
                           exp_str = datetime.datetime.utcfromtimestamp(exp).isoformat()
                     except Exception:
                           exp_str = "?"
                     return h, exp_str

               with open(NAMESPACE_PATH) as f:
                     ns = f.read().strip()

               config.load_incluster_config()
               v1 = client.CoreV1Api()
               start = time.time()
               last_hash = None

               while time.time() - start < 2100:
                     ts = datetime.datetime.utcnow().isoformat()
                     el = int(time.time() - start)
                     h, exp = token_fingerprint()
                     rotated = " <<< TOKEN FILE CHANGED" if (last_hash and h != last_hash) else ""
                     last_hash = h
                     try:
                           v1.list_namespaced_pod(ns, limit=1)
                           api = "OK 200"
                     except Exception as e:
                           api = f"FAIL {getattr(e, 'status', '?')}"
                     print(f"[{ts}] elapsed={el}s file_hash={h} file_exp={exp} api={api}{rotated}", flush=True)
                     time.sleep(30)

               print("=== done ===", flush=True)
               PY
         volumeMounts:
            - name: short-token
               mountPath: /var/run/secrets/kubernetes.io/serviceaccount
               readOnly: true
   volumes:
      - name: short-token
         projected:
            sources:
               - serviceAccountToken:
                     path: token
                     expirationSeconds: 600
               - configMap:
                     name: kube-root-ca.crt
                     items:
                        - key: ca.crt
                           path: ca.crt
               - downwardAPI:
                     items:
                        - path: namespace
                           fieldRef:
                              fieldPath: metadata.namespace
```

## What This Test Proves

The test pod does the following every 30 seconds:

1. Reads `/var/run/secrets/kubernetes.io/serviceaccount/token`.
1. Prints a short SHA-256 fingerprint of the token file.
1. Decodes JWT `exp` claim from the token payload.
1. Calls Kubernetes API (`list_namespaced_pod`) using the in-cluster client.
1. Prints whether API call succeeded (`OK 200`) or failed (for example `FAIL 401`).

If the token fingerprint changes and API calls remain `OK 200`, token rotation and client re-use are working.

## Prerequisites

1. Use a non-production cluster.
1. Keep auth mode as close as possible to the target environment.
1. Use an image that includes `python3` and Python package `kubernetes`.
1. You can create SA/Role/RoleBinding/Pod in namespace `default`.

## Important Manifest Notes

1. `automountServiceAccountToken: false` is intentional.
   - This guarantees only the projected short-lived token is used.
1. Projected token path is mounted at:
   - `/var/run/secrets/kubernetes.io/serviceaccount/token`
1. `expirationSeconds: 600` means 10 minutes.
   - If you want faster boundary testing, lower this value (for example `120`).

## Run the Test

Save the manifest from this document as `token-refresh-test.yaml`, then apply it:

```bash
kubectl apply -f token-refresh-test.yaml
```

Wait for pod to start:

```bash
kubectl -n default get pod token-refresh-test -w
```

Stream logs:

```bash
kubectl -n default logs -f pod/token-refresh-test
```

## How to Read the Output

Example line:

```text
[2026-08-11T10:10:00] elapsed=600s file_hash=abcd1234ef56 file_exp=2026-08-11T10:20:01 api=OK 200 <<< TOKEN FILE CHANGED
```

Field meanings:

1. `elapsed`: seconds since test started.
1. `file_hash`: token file fingerprint (changes when token file rotates).
1. `file_exp`: JWT expiration time (UTC) from the token file.
1. `api`: result of Kubernetes API call.
1. `<<< TOKEN FILE CHANGED`: detected token file rotation event.

## Interpretation Matrix

1. `file_hash` changes and `api=OK 200` continues
   - Healthy behavior.
   - Token rotates and client is authenticating successfully.
1. `file_hash` changes, then `api=FAIL 401`
   - Token rotates, but client/auth path is failing after refresh.
   - Often points to auth integration mismatch or stale credential handling.
1. `file_hash` never changes and eventually `api=FAIL 401`
   - Rotation not happening or projected token not being updated.
   - Check kubelet token projection and volume mount behavior.
1. `api=FAIL 403` with stable behavior
   - Authentication likely works, authorization is missing.
   - RBAC issue, not token validity issue.

## Quick Checks During Investigation

Check current token file metadata in pod:

```bash
kubectl -n default exec -it token-refresh-test -- ls -l /var/run/secrets/kubernetes.io/serviceaccount
```

Check current token `exp` directly in pod:

```bash
kubectl -n default exec -it token-refresh-test -- python3 - <<'PY'
import base64, json, datetime
p='/var/run/secrets/kubernetes.io/serviceaccount/token'
t=open(p).read().strip().split('.')[1]
t += '=' * (-len(t) % 4)
exp=json.loads(base64.urlsafe_b64decode(t.encode()))['exp']
print(datetime.datetime.utcfromtimestamp(exp).isoformat())
PY
```

## Common Root Causes If Refresh Fails

1. Workload keeps an old token value in memory and does not re-read file.
1. Kubernetes client version behavior differs from production image.
1. Wrong token path mounted or default token path unexpectedly used.
1. Cluster auth webhook / aws-iam-authenticator mapping inconsistency.
1. Clock skew between node and control plane causing early/late expiry behavior.

## Cleanup

```bash
kubectl -n default delete pod token-refresh-test --ignore-not-found
kubectl -n default delete rolebinding token-refresh-test --ignore-not-found
kubectl -n default delete role token-refresh-test --ignore-not-found
kubectl -n default delete sa token-refresh-test --ignore-not-found
```

## Suggested Follow-Up

If you reproduce a post-rotation `401`:

1. Capture full test logs.
1. Record token hash transition timestamps and first failing timestamp.
1. Compare with apiserver/authenticator logs around that window.
1. Re-run with a shorter `expirationSeconds` to accelerate reproductions.
