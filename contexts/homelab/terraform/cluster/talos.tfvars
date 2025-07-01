// Managed by Windsor CLI: This file is partially managed by the windsor CLI. Your changes will not be overwritten.
// Module source: github.com/windsorcli/core//terraform/cluster/talos?ref=v0.3.0

// The external controlplane API endpoint of the kubernetes API
cluster_endpoint = "https://192.168.1.142:6443"

// The name of the cluster
cluster_name = "talos"

// A YAML string of common config patches to apply
common_config_patches = <<EOF
"cluster":
  "apiServer":
    "certSANs":
    - "localhost"
    - "192.168.1.142"
  "extraManifests":
  - "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/v0.8.7/deploy/standalone-install.yaml"
"machine":
  "certSANs":
  - "localhost"
  - "192.168.1.142"
  "kubelet":
    "extraArgs":
      "rotate-server-certificates": "true"
  "network": {}
EOF

// A YAML string of controlplane config patches to apply
controlplane_config_patches = <<EOF
machine:
  sysctls:
    vm.max_map_count: 262144
  features:
    kubernetesTalosAPIAccess:
      enabled: true
      allowedRoles:
        - os:etcd:backup
      allowedKubernetesNamespaces:
        - kube-system
EOF

// Machine config details for control planes
controlplanes = [
  {
    "node" : "192.168.1.142",
    "endpoint" : "192.168.1.142:50000"
  }
]

// A YAML string of worker config patches to apply
worker_config_patches = <<EOF
machine:
  sysctls:
    vm.max_map_count: 262144
  kubelet:
    extraMounts:
      - destination: /var/lib/openebs
        type: bind
        source: /var/lib/openebs
        options:
          - rbind
          - rw
      - destination: /var/local-path-provisioner
        type: bind
        source: /var/local-path-provisioner
        options:
          - bind
          - rshared
          - rw
  files:
    - content: |
        [plugins]
          [plugins."io.containerd.grpc.v1.cri"]
            device_ownership_from_security_context = true
      path: /etc/cri/conf.d/20-customization.part
      op: create
EOF

workers = [
  {
    "node" : "192.168.1.139",
    "endpoint" : "192.168.1.139:50000"
  },
  {
    "node" : "192.168.1.148",
    "endpoint" : "192.168.1.148:50000"
  }
]

talos_version = "1.10.4"
