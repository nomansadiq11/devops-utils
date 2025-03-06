# SSH Host Key changed

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:************************
Please contact your system administrator.
.
.
.
Host key verification failed.

## When Happen

I have created EC2 machine and configure my application and bind with private ip. After few days I deleted/terminated the instance but I took the backup
Again few days I need to run the application, I lanuch the instance from AMI backup and started my machine but application was not starting up due to IP changed.
Again I deleted and created new machine with same PrivateIP (Luckily it was available) and try to ssh into and got above message.

## How to solve it

remove the old entry in your `~/.ssh/known_hosts`

```bash
ssh-keygen -R {privateip}
```

and ssh again to machine

```bash
ssh user@{privateip}
```
