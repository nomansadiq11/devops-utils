# How we can delete the merged branches

## Usecase

In our local we are working as trunk base development, like create new feature branch and merged to your main branch.
Once merged successfully, it's deleted from remote but no your local

This script will find the `gone` branches and delete it locally and remote

```bash

for b in $(git branch -vv | awk '/: gone]/{print $1}'); do
  git branch -D "$b"
done

```
