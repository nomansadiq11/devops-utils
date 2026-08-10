# Kubernetes Service Account Token: Read and Validate

This guide shows how to read a Kubernetes service account token from a running pod and check whether it is still valid.

## What You Can Check

1. Decode token claims (exp, iat, aud, sub).
1. Confirm if the token is expired.
1. Optionally verify token acceptance by the Kubernetes API server.

## Where the Token Is Mounted

Inside a pod, the service account token is usually mounted at:

```bash
/var/run/secrets/kubernetes.io/serviceaccount/token
```

## Python Script to Decode Token Claims

Use this script inside a pod (or any environment where that token file is available):

```python
import base64
import datetime
import json

with open("/var/run/secrets/kubernetes.io/serviceaccount/token") as f:
    token = f.read().strip()

payload = token.split(".")[1]
payload += "=" * (-len(payload) % 4)
data = json.loads(base64.urlsafe_b64decode(payload.encode()).decode())

exp = datetime.datetime.utcfromtimestamp(data["exp"])
iat = datetime.datetime.utcfromtimestamp(data["iat"])
now = datetime.datetime.utcnow()

print("exp:", exp)
print("iat:", iat)
print("aud:", data.get("aud"))
print("sub:", data.get("sub"))
print("now:", now)
print("is_expired:", now >= exp)
```

## Run It Quickly in a Pod

```bash
kubectl exec -it <pod-name> -n <namespace> -- python3 - <<'PY'
import base64
import datetime
import json

with open('/var/run/secrets/kubernetes.io/serviceaccount/token') as f:
    token = f.read().strip()

payload = token.split('.')[1]
payload += '=' * (-len(payload) % 4)
data = json.loads(base64.urlsafe_b64decode(payload.encode()).decode())

exp = datetime.datetime.utcfromtimestamp(data['exp'])
iat = datetime.datetime.utcfromtimestamp(data['iat'])
now = datetime.datetime.utcnow()

print('exp:', exp)
print('iat:', iat)
print('aud:', data.get('aud'))
print('sub:', data.get('sub'))
print('now:', now)
print('is_expired:', now >= exp)
PY
```

## Important Note About "Validation"

Decoding JWT claims only reads token contents. It does not cryptographically verify signature validity.

To validate that Kubernetes accepts the token, use TokenReview:

```bash
kubectl create -f - <<EOF
apiVersion: authentication.k8s.io/v1
kind: TokenReview
spec:
  token: "<PASTE_TOKEN_HERE>"
EOF
```

Check `status.authenticated: true` in the response.

## Common Claims

- `exp`: Expiration time (UTC).
- `iat`: Issued-at time (UTC).
- `aud`: Intended audience.
- `sub`: Subject, typically `system:serviceaccount:<namespace>:<serviceaccount-name>`.

## Troubleshooting

- File not found:
- Pod may not have automounted token. Check pod/service account `automountServiceAccountToken`.
- Token appears expired:
- Restart pod to get a fresh projected token (if rotation is not active for your workload).
- TokenReview denied:
- Ensure API access and RBAC allow the review operation.
