# How we can delete the merged branches

## Usecase

In our local we are working as trunk base development, like create new feature branch and merged to your main branch.
Once merged successfully, it's deleted from remote but no your local

This script will find the `gone` branches and delete it locally and remote

Step 1 : run this command, will ensure local branchs are gone

```bash
git fetch --prune
```

Step 2 : run below command clean the gone branches

```bash

for b in $(git branch -vv | awk '/: gone]/{print $1}'); do
  git branch -D "$b"
done

```
