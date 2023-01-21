#!/bin/bash -eu

# Create sicily cluster
kind create cluster --config=kind-config-sicily.yaml --kubeconfig=$(echo $HOME)/.kube/default-config --image kindest/node:v1.23.0 --wait 5m