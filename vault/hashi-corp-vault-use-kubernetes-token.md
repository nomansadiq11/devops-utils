# How we can use Kubernetes Token to Authenticate with vault

## Usecase

We need service account in vault but service account itself maanging is very important job, that can leakage and will be security threat.

So here is an example to fetch `Kubernetes` ServiceAccount Token and use it to get secrets from vault

Before that you need to have inject Kubernetes pods with vault, Once you injected vault with `Kubernetes` pods you wil have Service Account token

Complete Code Example

```python

import hvac

# Vault and Kubernetes settings
VAULT_ADDR = "https://vault.com"
VAULT_ROLE = "role_name"
KUBE_AUTH_PATH = "kubernetes"
SECRET_PATH = "application/config"


# Read the Kubernetes service account token
with open("/var/run/secrets/kubernetes.io/serviceaccount/token", "r") as f:
    jwt = f.read()

# Initialize Vault client
client = hvac.Client(url=VAULT_ADDR)

# Authenticate with Vault
auth_response = client.auth.kubernetes.login(role=VAULT_ROLE, jwt=jwt, mount_point=KUBE_AUTH_PATH)
client.token = auth_response["auth"]["client_token"]


print("Vault authentication successful!")

# # Retrieve secret from Vault
secret_response = client.secrets.kv.v2.read_secret_version(path=SECRET_PATH)
secret_value = secret_response["data"]["data"]

print("Retrieved Secret:", secret_value)


```
