# How we can run stress test on an API

## Usecase

I had this usecase, I need to test an API by running stress test. I choose to use kubernetes for this purpose

Build your docker image by using this dockerfile

```Dockerfile
FROM grafana/k6:latest

# Create a directory for scripts
RUN mkdir -p /scripts

WORKDIR /scripts

CMD ["run", "/scripts/test.js"]

```

create a config map with following script

```js
import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
  vus: 20,
  duration: '30m',
};

export default function () {
  http.get('https://your-api.com/endpoint');
  sleep(1);
}

```

```bash
kubectl create configmap k6-script --from-file=test.js

```

```yaml
# k6-job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: test-api
spec:
  template:
    spec:
      containers:
      - name: k6
        image: your-dockerhub/k6-runner:latest
        volumeMounts:
        - name: k6-script-volume
          mountPath: /scripts
      restartPolicy: Never
      volumes:
      - name: k6-script-volume
        configMap:
          name: k6-script
  backoffLimit: 0

```
