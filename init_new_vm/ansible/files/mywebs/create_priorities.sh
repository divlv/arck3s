#!/bin/bash

# Create priority deployments first
k3s kubectl apply -f high-priority.yaml
sleep 1
k3s kubectl apply -f low-priority.yaml
sleep 1
