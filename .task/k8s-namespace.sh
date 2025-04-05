#!/bin/bash

ns=$(kubectl get ns --no-headers | \
  awk '{print $1}' | \
  sort -d | \
  fzf --height 40% --border --border-label="╢ Select k8s Namespace ╟"
)
if [ -n "$ns" ]; then
    kubectl config set-context --current --namespace "$ns"
fi
