#!/bin/bash

# Create a directory to store individual YAML files
mkdir -p recent_pods

# Get the JSON output of pods
kubectl get pods -n default -o json | jq -c '.items[]' > all_pods.json

# Iterate over each pod
cat all_pods.json | while IFS= read -r pod; do
  # Check if the pod starts with "wf-hc" and is created within the last 12 hours
  if echo "$pod" | jq -e '(now - (.metadata.creationTimestamp | fromdateiso8601)) < 43200' > /dev/null; then
    # Extract the name of the pod
    name=$(echo "$pod" | jq -r '.metadata.name')
    # Save the pod to a YAML file in the recent_pods directory
    echo "$pod" | yq eval -P - > "recent_pods/${name}.yaml"
  fi
done

# Clean up
rm all_pods.json
