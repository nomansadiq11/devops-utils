# how to setup tunnel

- let suppose if you want to access a website to your local without accessing the Jumpbox
- you can set the tunnel with jumpbox

## here is how

> ~/.ssh/config

```bash

Host jb
     HostName jb.com
     User username
     #### Dev Endpoints
     LocalForward 127.0.0.1:9876 website.com:80


```

> /etc/hosts

```bash

127.0.0.1 website.com

```

- After above configuration ssh into jb and start accessing website.com:9876

> if you want to proxyjump

```bash
Host server1
     HostName 10.0.0.1
     User username
     IdentityFile ssh-key-path
     ProxyJump proxyjumbboxip-ordns
```
