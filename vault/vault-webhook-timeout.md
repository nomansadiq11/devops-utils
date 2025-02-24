# Why to increase the Vault Webhook timeout

## Problem

We have an issue, our pods were failing due to vault:init error, after troubleshoot found that vault webhook not able to get response within time limit which is default timeout is 10s

## Solution 1

Increase the timeout to 30s which will solve the issue

## Solution 2

Increase the resouces for vault so that vault can process the request within time
