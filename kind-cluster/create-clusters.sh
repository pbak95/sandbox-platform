#!/bin/bash -eu

# Create sicily cluster
kind create cluster --config=kind-config-sicily.yaml --kubeconfig=$(echo $HOME)/.kube/default-config