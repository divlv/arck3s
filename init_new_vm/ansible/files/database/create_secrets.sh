#!/bin/bash

# Creating secrets for various DB-related services...
k3s kubectl apply -f db-secrets.yaml
sleep 1
