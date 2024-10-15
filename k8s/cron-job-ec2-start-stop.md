# Kubernetes Cronjob

## Usecase

- There is automation reqquire to start and stop the instance in AWS
- So I created cronjob in kubernetes todo this operation

```yaml

apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: my-cronjob-test
  labels:
    app: test-cron
spec:
  schedule: "*/1 * * * *"  # Define your desired schedule
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccountName: my-sa-test
          containers:
          - name: my-container
            labels:
              app: test-cron
            image: cli-utils-latest
            volumeMounts:
            - name: my-script-volume
              mountPath: /app
            # args: ["false", "123", "abc", "start"]  # Example arguments
            # command: ["/bin/sh", "-c", "bash /app/script.sh true instance arn:aws:iam::123123456:role/prod-role  start"]
            command: ["/bin/bash", "-c", "source /app/script.sh; aws sts get-caller-identity;"]
          volumes:
          - name: my-script-volume
            configMap:
              name: instance-start-stop-configmap  # Replace with your ConfigMap name
          restartPolicy: OnFailure

```

```yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: instance-start-stop-configmap
data:
  script.sh: |
    #!/bin/bash -xe

    help() {
        echo "USAGE:"
        echo ""
        echo "   Two parameters are accepted"
        echo ""
        echo "   Parameter 1: A comma separated list of instance_ids"
        echo "   Parameter 2: An optional IAM role to assume"
        echo ""
        echo "   Example usage:"
        echo "   this-scrip.sh instance_id1,instance_id2 arn:aws:iam::xyz:role/cicd-ec2-access"
        echo ""
    }

    parse_args() {
        count="$#"

        if [ "$count" -eq 0 ]; then
            echo "At least one parameter is required."
            help
            # exit 1
        fi

        if [ "$count" -gt 2 ]; then
            echo "A maximum of 2 parameters are allowed."
            help
            # exit 1
        fi
    }

    assume_role() {
        if [ -n "$2" ]; then
            credentials=$(aws sts assume-role \
                --role-arn "$2" \
                --role-session-name AWSCLI-Session
            )

            export AWS_ACCESS_KEY_ID=$(jq -re '.Credentials.AccessKeyId' <<< $credentials)
            export AWS_SECRET_ACCESS_KEY=$(jq -re '.Credentials.SecretAccessKey' <<< $credentials)
            export AWS_SESSION_TOKEN=$(jq -re '.Credentials.SessionToken' <<< $credentials)

            echo "Will use $(aws sts get-caller-identity) to perform operations."
        fi
    }

    shutdown() {
        parse_args "$@"
        assume_role "$@"

        instance_ids=$(tr ',' ' ' <<< $1)

        # Stop instances
        for instance_id in $instance_ids; do
            echo "Stopping instance $instance_id ..."
            aws ec2 stop-instances --instance-ids $instance_id
        done

        # Wait for the instances to fully shutdown
        for instance_id in $instance_ids; do
            echo "Waiting for instance $instance_id to fully stop .."
            aws ec2 wait instance-stopped --instance-ids $instance_id
        done

    }

    startup() {
        parse_args "$@"
        assume_role "$@"

        instance_ids=$(tr ',' ' ' <<< $1)

        # Stop instances
        for instance_id in $instance_ids; do
            echo "Starting instance $instance_id ..."
            aws ec2 start-instances --instance-ids $instance_id
        done

        # Wait for the instances to fully startup
        for instance_id in $instance_ids; do
            echo "Waiting for instance $instance_id to fully start .."
            aws ec2 wait instance-running --instance-ids $instance_id
        done

    }


```

> Test your job by creating the pod, ssh into pod and see yoru configMap and try to run the script

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-cronjob-awscli-test
  labels:
    app: awscli
spec:
  serviceAccountName: cronjobs
  containers:
  - image: amazon/aws-cli
    command:
      - "sleep"
      - "604800"
    imagePullPolicy: IfNotPresent
    name: awscli
    volumeMounts:
    - name: my-script-volume
        mountPath: /app
  volumes:
  - name: my-script-volume
    configMap:
    name: instance-start-stop-configmap  # Replace with your ConfigMap name
  restartPolicy: Alwaysls
```

> service account

```yaml

kind: ServiceAccount
apiVersion: v1
metadata:
  name: my-sa-test
  labels:
    app: test-cron

```
