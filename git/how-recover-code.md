# How we can recover the code if somebody over write it

## Usecase

If someone overwrite your work by mistaken and you want to recover your work

## Solution

You can look for git logs, this will shows you all the commits and commit IDs

```sh
git reflog
```

create new branch from commit id raise pr and merge to `main` branch

```sh
# create new branch from commit id efgh456
git checkout -b recover-work efgh456
```
