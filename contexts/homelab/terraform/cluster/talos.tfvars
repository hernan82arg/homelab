// Managed by Windsor CLI: This file is partially managed by the windsor CLI. Your changes will not be overwritten.
// Module source: github.com/windsorcli/core//terraform/cluster/talos?ref=v0.3.0

// The external controlplane API endpoint of the kubernetes API
cluster_endpoint = "https://192.168.1.137:6443"

// The name of the cluster
cluster_name = "talos"

// A YAML string of common config patches to apply
common_config_patches = <<EOF
"cluster":
  "apiServer":
    "certSANs":
    - "localhost"
    - "192.168.1.137"
  "extraManifests":
  - "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/v0.8.7/deploy/standalone-install.yaml"
"machine":
  "certSANs":
  - "localhost"
  - "192.168.1.137"
  "kubelet":
    "extraArgs":
      "rotate-server-certificates": "true"
  "network": {}
EOF

// A YAML string of controlplane config patches to apply
controlplane_config_patches = ""

// Machine config details for control planes
controlplanes = [
  {
    "node" : "192.168.1.137",
    "endpoint" : "192.168.1.137:50000"
  }
]

// A YAML string of worker config patches to apply
worker_config_patches = <<EOF
machine:
    kubelet:
        extraMounts:
            - destination: /var/lib/openebs
              type: bind
              source: /var/lib/openebs
              options:
                - rbind
                - rw
EOF

workers = [
  {
    "node" : "192.168.1.138",
    "endpoint" : "192.168.1.138:50000"
  },
  {
    "node" : "192.168.1.141",
    "endpoint" : "192.168.1.141:50000"
  }
]
