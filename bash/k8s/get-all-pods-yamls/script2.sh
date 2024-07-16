#!/bin/bash

for deployment in $(kubectl get deployment -n default | awk '{print $1}'); do
  kubectl get deployment -n default $deployment -o yaml
done > dlaworkflows.yaml
