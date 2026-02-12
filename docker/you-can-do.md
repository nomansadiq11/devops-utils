# Docker Useful Commands

If you want overwrite docker entrypoint, we can do this by using this

```bash
docker run -it --entrypoint /bin/bash {docker-image-name}
```

You can build docker image in multiple CPU Architecture

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t your-dockerhub-username/your-image:tag \
  --push .

```

if you want to build only for 'amd64' then we can remove 'arm64' from the command

```bash
docker buildx build \
  --platform linux/amd64 \
  -t your-dockerhub-username/your-image:tag \
  --push .

```
