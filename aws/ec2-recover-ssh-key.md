# How to recover EC2 Lost SSH

## Problem

Somehow lost the ssh key and couldn't login again with EC2 machine.

## Solution 1 Recover Using Bootstrap Script

Documentation link <https://repost.aws/knowledge-center/user-data-replace-key-pair-ec2>

if ec2 machine doesn't configure the bootstrap script you can run script to add your public key in ec2-user

```bash
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [users-groups, once]
users:
  - name: username
    ssh-authorized-keys:
     - PublicKeypair
```

## Solution 2 Recover with Deattached the root Volume and add SSH key

If solution 1 doesn't works, then you have todo with solution 2

1. Shutdown server
1. Deattached root volume
1. Create new EC2 machine or use existing EC2 machine to attach this volume
1. Mount the volume `mkdir newvol` and `mount -m newvol`
1. Go to /home/ec2-user/.ssh/
1. add your public key in Authorized file
1. Deattached this volumen and attached back with old server
1. start the server and try to ssh ec2-user@{ip}