# Unable to get vault values due to following error

## Problem

Sometime there is issue to getting vault values from hashicorp vault due to TLS/SSL renewed, and vault mutationwebhook not udpated properly.

Error `remote error: tls: bad certificate`

## Solution 1

Remove the `mutatingwebhookconfiguration` secret/config and recreate it
