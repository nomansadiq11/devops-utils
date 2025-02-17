# Auditd Service failed to start

## Solution

run this and see the pid

```bash
auditctl -s
```

output something like this

```text
enabled 1
failure 0
pid 1398
rate_limit 10000
backlog_limit 16384
lost 24275
backlog 7
backlog_wait_time 15000
loginuid_immutable 0 unlocked
```

here you see the pid is 1398, now check which service using this pid

```bash
ps -ef | grep -i 1398
```

output something like this

```text
root        1398     499  0 09:04 ?        00:00:13 /opt/fireeye/bin/xagt --mode Eventor --iofd 3 --cmname 12 --log INFO --logfd 4
root       14803   14356  0 10:24 pts/0    00:00:00 grep --color=auto -i 1398
```

In this case my pid used by some other service, now stop that service and start your auditd service

```bash
sudo systemctl stop xagt
sudo systemctl disable xagt
```
