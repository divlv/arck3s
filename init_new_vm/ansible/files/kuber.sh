#!/bin/bash

#
# Run this file first to set up the server for K3s:
#

# This is needed for SSL certs
mkdir -p /opt/traefik-data
chmod 777 /opt/traefik-data

# PostgreSQL data directory
mkdir -p /data/postgres
chmod 777 /data/postgres

curl -sfL https://get.k3s.io | sh -

sleep 5

mkdir -p /var/lib/rancher/k3s/server/manifests


ln -s /var/lib/rancher/k3s/server/manifests /opt/manifests

k3s kubectl create namespace mywebs

#Register Logs helper tools
/opt/install/tools/register

#rm -f /opt/tmp_*.*

k3s kubectl apply -f traefik-acme-pv.yaml
sleep 1
k3s kubectl apply -f traefik-acme-pvc.yaml
sleep 5
k3s kubectl apply -f traefik-redirect-www.yaml
sleep 5

# Creating access for Skooner K3s Dashboard:
k3s kubectl apply -f skooner-sa-rbac.yaml
sleep 1

mv /opt/install/traefik-config.yaml /var/lib/rancher/k3s/server/manifests/traefik-config.yaml

sudo systemctl restart k3s


# touch /opt/_server_setup_finished_
# touch /root/_server_setup_finished_