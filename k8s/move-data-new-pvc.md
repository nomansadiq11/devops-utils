# Move PVC data to new PVC

## Usecase

- in some cases you need to migrate the application from one kubernetes cluster to another cluster
- if you application using EFS mounted as PVC

## Solution

- Install the application new cluster
- mount the EFS as PVC
- `SSH` to the node

> Mount PVC to the node

```bash

# create directory
mkdir tmpefs/

# mount he efs
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-5teart4g.efs.us-east-1.amazonaws.com:/   tmpefs/

```
