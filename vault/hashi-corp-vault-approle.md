# How to create service account in hashi-corp vault

## Solution

We need to use approle auth mechanism, which will allow us to create roleid and secretid

### Step 1 enable the approle auth from UI or vault CLI

### Step 2 create policy with permission

```hcl
path "secret/data/connections/*" {
  capabilities = ["read"]
}
```

and create policy

```shell

vault policy write policy_name policy.hcl

```

### Step 3 create role

```shell

vault write auth/approle/role/role_name \
    token_policies="policy_name" \
    token_ttl=1h \
    token_max_ttl=4h

```

### Step 3 get role_id and secret_id

```shell
vault write -f auth/approle/role/role_name/secret-id
```

```shell
vault read auth/approle/role/role_name/role-id
```

### Step 4 test the role_id and secret_id using python lib hvac

```python

import hvac

vault_url = "https://vault.local.com"
role_id = "add your role id"
secret_id = "add your secret id"

client = hvac.Client(url=vault_url, verify=True)

# Authenticate using AppRole
auth_response = client.auth.approle.login(role_id=role_id, secret_id=secret_id)
vault_token = auth_response["auth"]["client_token"]

# Use the token for subsequent requests
client.token = vault_token
print(vault_token)

# Retrieve a secret from Vault
secret_path = "connections/"
secret_response = client.secrets.kv.v2.read_secret_version(path=secret_path)

print("Secret data:", secret_response["data"]["data"])

```
