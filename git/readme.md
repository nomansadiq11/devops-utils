# git commands quick Help

## remove last commit and reset to main branch

```bash
git reset --hard HEAD~1
git fetch origin
git pull origin main
```

## If you want to delete last commit but keep its changes

```sh
git reset --soft HEAD~1
git fetch origin
git pull origin main
```
