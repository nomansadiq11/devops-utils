# Unable to download docker imnage

## Error

```bash
36d214fd9779: Download complete
failed to register layer: open /var/lib/docker/overlay2/0de37b6f2303b076f80437226f64042b0e7c6d2391ab35336635a506bc31dc61/committed: no such file or directory
```

## Solution

After some research on google I found that docker lib folder have some currpted files so the solution suggested as

```bash
sudo systemctl stop docker
sudo rm -rf /var/lib/docker/overlay2/*
sudo systemctl start docker
```

or

```bash
sudo systemctl stop docker
sudo rm -rf /var/lib/docker/*
sudo systemctl start docker
```
