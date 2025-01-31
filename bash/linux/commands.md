# Linux Commands or Utilities

you shouldn't write the commands somewhere to remember it but sometimes you need to find quick way.

so here I will write


> Check Disk space usage by each folder in directory

```
du -sch *               # here * is path in current director
du -sch /var/log/       # here add path to find diskspace usage by
du -h --exclude=/var/log/ # exclude the path

# check folder size and sort by k2
du -sh * | sort -k2

# check folder size sort by size
du -sh * | sort -hr
```

> find files in specfic path older than n number of days

```
find . -mtime+3 # find files older than 3 days
```