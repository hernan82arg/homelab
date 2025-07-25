# Managed by Windsor CLI: This file is partially managed by the windsor CLI. Your changes will not be overwritten.
# Module source: github.com/windsorcli/core//terraform/cluster/talos?ref=main

# The kubernetes version to deploy.
# kubernetes_version = "1.33.3"

# The talos version to deploy.
# talos_version = "1.10.5"

# The name of the cluster.
cluster_name = "talos"

# The external controlplane API endpoint of the kubernetes API.
cluster_endpoint = ""

# A list of machine configuration details for control planes.
controlplanes = []

# A list of machine configuration details
workers = []

# A YAML string of common config patches to apply. Can be an empty string or valid YAML.
common_config_patches = <<EOF
"cluster":
  "apiServer":
    "certSANs":
    - "localhost"
    - ""
  "extraManifests":
  - "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/v0.8.7/deploy/standalone-install.yaml"
"machine":
  "certSANs":
  - "localhost"
  - ""
  "kubelet":
    "extraArgs":
      "rotate-server-certificates": "true"
  "network": {}
EOF


# A YAML string of controlplane config patches to apply. Can be an empty string or valid YAML.
controlplane_config_patches = ""

# A YAML string of worker config patches to apply. Can be an empty string or valid YAML.
worker_config_patches = ""
