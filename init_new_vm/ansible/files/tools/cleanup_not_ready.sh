#!/bin/bash

# cleanup_not_ready.sh
# PURPOSE: Delete resources in namespace "mywebs" whose READY column equals 0/x.
# WARNING: Run with caution; this is a destructive operation.

set -euo pipefail

NAMESPACE="mywebs"
RESOURCE_TYPES="deployments statefulsets daemonsets pods"

for TYPE in $RESOURCE_TYPES; do
  # List objects where the second column (READY) starts with 0/
  k3s kubectl get "$TYPE" -n "$NAMESPACE" --no-headers \
    | awk '$2 ~ /^0\// {print $1}' \
    | while read -r NAME; do
        echo "Deleting $TYPE/$NAME (ready=0) ..."
        k3s kubectl delete "$TYPE" "$NAME" -n "$NAMESPACE"
      done
done
