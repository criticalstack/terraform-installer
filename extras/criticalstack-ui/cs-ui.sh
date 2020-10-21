#!/bin/bash

helm repo add criticalstack https://charts.cscr.io/criticalstack
helm upgrade --install cs criticalstack/ui \
  --create-namespace \
  --namespace critical-stack
