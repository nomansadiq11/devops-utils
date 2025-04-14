# How to Enable the S3 as Filesystem in container

In your `Dockerfile` add this line, installing `fuse` and `s3fs`

```Dockerfile
RUN apt-get update && \
    apt-get install -y software-properties-common fuse s3fs
```

Add this command also to enable the fuse on host node (without it, this will not work )

```Dockerfile
RUN modprobe fuse
```

trying to interact with newly build image like this

```shell
docker run -it imagename:tag /bin/bash
```

Configure the S3 keys in envirnment variables

```shell
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
```

Inside the shell

```shell
# create directory
mkdir /s3-files

s3fs s2-bucket-name /s3-files \
    -o allow_other \
    -o use_path_request_style \
    -o url=https://s3.eu-west-1.amazonaws.com \
     -o endpoint=eu-west-1 \
    -o dbglevel=info
```

After configuration run this

```shell
ls /s2-files
```

you will able to see the files which exists in your s3 bucket
