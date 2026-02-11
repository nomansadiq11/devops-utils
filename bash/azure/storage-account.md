# Connect with Azure Storeage Account and Upload files using Azure az

Upload file to storage account

```bash

az storage blob upload \
  --account-name {storage-account-name} \
  --container-name {container-name} \
  --name os-release \
  --file ./os-release \
  --sas-token ""

```

List the objects in storage account

```bash

 az storage blob list \
  --account-name {storage-account-name} \
  --container-name {container-name} \
  --sas-token "" \
  --output table

```

## how we can do in python

List the files

```py

from azure.storage.blob import ContainerClient

# --- Configuration ---
account_url = "https://{storage-account-name}.blob.core.windows.net"
container_name = "{container_name}"
sas_token = "{token}"

# --- Create container client using SAS token ---
container_client = ContainerClient.from_container_url(
    container_url=f"{account_url}/{container_name}{sas_token}"
)

# --- List blobs ---
print(f"Files in container '{container_name}':\n")
for blob in container_client.list_blobs():
    print(f"- {blob.name}")

```

Upload the files

```py

from azure.storage.blob import BlobClient

# --- Configuration ---
account_url = "https://{storage-account-name}.blob.core.windows.net"
container_name = "{container_name}"
sas_token = "{token}"  # e.
local_file_path = "os-release-2"  # e.g. "/tmp/os-release"
blob_name = "os-release-2"  # e.g. "os-release.txt"

# --- Create Blob Client ---
blob_client = BlobClient.from_blob_url(
    blob_url=f"{account_url}/{container_name}/{blob_name}{sas_token}"
)

# --- Upload the file ---
with open(local_file_path, "rb") as data:
    blob_client.upload_blob(data, overwrite=True)

print(f"✅ File '{local_file_path}' uploaded as '{blob_name}'")

```
