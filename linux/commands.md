# Linux Commands or Utilities

you shouldn't write the commands somewhere to remember it but sometimes you need to find quick way.

## Check Disk Space Usage by each folder in directory

```bash
du -sch *               # here * is path in current director
du -sch /var/log/       # here add path to find diskspace usage by
du -h --exclude=/var/log/ # exclude the path

# check folder size and sort by k2
du -sh * | sort -k2

# check folder size sort by size
du -sh * | sort -hr

# Sort by larget folder first - scan only folders
du -h --max-depth=1 | sort -hr

```

> find files in specfic path older than n number of days

```bash
find . -mtime+3 # find files older than 3 days
```

## Linux

> Check CPU Architecture

```shell
uname -m
```

> command to find the service package location

```bash
whereis kubelet
```

> Find files older than three days with max depth like folder level only in current directory

```bash
find . -maxdepth 1 -mtime 3
```
