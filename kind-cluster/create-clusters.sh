#!/bin/bash -eu

# Create sicily cluster
kind create cluster --config=kind-config-sicily.yaml --kubeconfig=$(echo $HOME)/.kube/default-config --image kindest/node:v1.27.2 --wait 5m