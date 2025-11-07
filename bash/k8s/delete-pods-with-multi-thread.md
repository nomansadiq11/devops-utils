# How we can delete pods with Multi threading

## Usecase

There are some cases when you need to delete thousands of pods and you need to run it as parallel jobs.
Why?
becuase API Server can process 30 requests 1 min, so you need to process more request by using another thread, then you can run below script as multi-thread

```bash
#!/bin/bash

# File containing pod names (one per line)
POD_LIST="podnames.txt"

# Namespace
NAMESPACE="nameOfNamespace"

# Number of pods to patch per batch
BATCH_SIZE=10

# Number of parallel threads
PARALLEL=100

echo $POD_LIST

# Command to patch finalizers
cat "$POD_LIST" | xargs -n $BATCH_SIZE -P $PARALLEL -I {} kubectl patch {} -n $NAMESPACE -p '{"metadata":{"finalizers":[]}}' --type=merge

echo "All pods in $POD_LIST patched in parallel."

```
