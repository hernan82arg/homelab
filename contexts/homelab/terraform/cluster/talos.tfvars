# Managed by Windsor CLI: This file is partially managed by the windsor CLI. Your changes will not be overwritten.
# Module source: github.com/windsorcli/core//terraform/cluster/talos?ref=main

# The kubernetes version to deploy.
kubernetes_version = "1.33.3"

# The talos version to deploy.
talos_version = "1.10.6"

# The name of the cluster.
cluster_name = "talos"

# The external controlplane API endpoint of the kubernetes API.
cluster_endpoint = "https://192.168.1.59:6443"

# A list of machine configuration details for control planes.
controlplanes = [{
  endpoint  = "192.168.1.59:50000"
  hostname  = "controlplane-1"
  hostports = []
  node      = "192.168.1.59"
}]

# A list of machine configuration details
workers = [{
  endpoint  = "192.168.1.50:50000"
  hostname  = "worker-1"
  hostports = ["8080:30080/tcp", "8443:30443/tcp", "9292:30292/tcp", "8053:30053/udp"]
  node      = "192.168.1.50"
},
{
  endpoint  = "192.168.1.53:50000"
  hostname  = "worker-2"
  hostports = ["8080:30080/tcp", "8443:30443/tcp", "9292:30292/tcp", "8053:30053/udp"]
  node      = "192.168.1.53"
}]

# A YAML string of common config patches to apply. Can be an empty string or valid YAML.
common_config_patches = <<EOF
"cluster":
  "apiServer":
    "certSANs":
    - "localhost"
    - "192.168.1.59"
  "extraManifests":
  - "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/v0.8.7/deploy/standalone-install.yaml"
"machine":
  "certSANs":
  - "localhost"
  - "192.168.1.59"
  "kubelet":
    "extraArgs":
      "rotate-server-certificates": "true"
  "network": {}
EOF


# A YAML string of controlplane config patches to apply. Can be an empty string or valid YAML.
controlplane_config_patches = <<EOF
machine:
  features:
    kubernetesTalosAPIAccess:
      enabled: true
      allowedRoles:
      - os:etcd:backup
      allowedKubernetesNamespaces:
      - default
EOF

# A YAML string of worker config patches to apply. Can be an empty string or valid YAML.
worker_config_patches = ""
