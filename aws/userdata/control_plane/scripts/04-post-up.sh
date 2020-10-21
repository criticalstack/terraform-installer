#!/bin/bash


#####################################################################
# Post-up script
#####################################################################

mkdir -p /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config

export KUBECONFIG=/root/.kube/config

helm repo add criticalstack https://charts.cscr.io/criticalstack

helm install cilium criticalstack/cilium \
    --namespace kube-system \
    --set global.prometheus.enabled=true \
    --version 1.7.1
