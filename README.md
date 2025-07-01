# homelab

## This is the configuration for my Homelab

![Homelab Architecture](img/homelab.jpg)

## Hardware Specs:

### Kubernetes cluster

- 1 Dell Optiplex 7040 (i5 4CPU, 32Gb, 256Gb SSD) as Control Plane
- 2 Dell Optiplex 7050 (i7 8CPU, 32Gb, 256Gb SSD) as Worker Nodes

### Extra Hardware

- Dell Optiplex 7040 (i5 4CPU, 32Gb, 1Tb SSD) as NFS/Plex/Samba
- WD 4Tb as extra storage
- Raspberry Pi 4 as Tailscale exit node
- Intel NUC (i7 16 Cores, 32Gb, 1Tb NVMe)
- 8 Port Switch 1Gbps
- 4 Port KVM
- 10" Screen

All mounted on a [DeskPi RackMate T1](https://deskpi.com/products/deskpi-rackmate-t1-2)

## I use windsor [cli](https://github.com/windsorcli/cli) to bootstrap and manage all the configuration.

### Modules in the `blueprint.yaml` are pulled from: https://github.com/windsorcli/core

## Kustomizations

The homelab uses Kustomize to manage Kubernetes manifests. The main kustomizations are:

### Infrastructure Services

Core infrastructure services are configured via kustomize:

- Storage classes and volumes
- Networking (CNI, load balancers)
- Monitoring stack (Prometheus & Grafana)
- Backup solutions
- Logging with EFK

The kustomizations allow for easy customization while maintaining consistency across the cluster.

### Kubevirt

KubeVirt is a virtualization add-on for Kubernetes that allows running virtual machines alongside containers. It enables:

- Running traditional VM workloads natively in Kubernetes
- Managing VMs using standard Kubernetes APIs and tools
- Integrating VMs with other Kubernetes resources like services, storage, and networking
- Live migration of VMs between nodes
- VM snapshots and clones

The Containerized Data Importer (CDI) is a complementary project that provides:

- Importing, uploading and managing VM disk images
- Converting between different formats (QCOW2, RAW, etc)
- Data volume management integrated with Kubernetes storage
- Automated import of images from HTTP/S3 sources
- Support for various storage backends (local, NFS, Ceph)

Together, KubeVirt and CDI provide a complete VM management solution within Kubernetes, allowing seamless operation of both containers and VMs in the same cluster.

### Services

Tapo Smart Home Integration

The homelab includes services for managing TP-Link Tapo smart home devices:

#### Tapo-REST API Service

A REST API service that provides HTTP endpoints for controlling Tapo devices:

- Device discovery and management
- Light control (on/off, brightness, color)
- Smart plug control
- Device status monitoring
- Authentication handling
- Swagger API documentation

#### Tapo-Web Frontend

A web-based frontend for interacting with Tapo devices:

- Device dashboard showing all connected devices
- Individual device controls
- Scene management
- Scheduling capabilities
- Mobile-friendly responsive design
- Dark/light theme support

The services work together to provide a complete solution for managing Tapo smart home devices through both API and web interfaces.

## Windows VMs

The homelab includes several Windows virtual machines running on KubeVirt:

- Windows 10 (win10-vm)
- Windows 11 (win11-vm)
- Windows Server 2019 (win2019-vm)
- Windows Server 2022 (win2022-vm)

The VMs are created from QCOW2 disk images that are built using Packer and QEMU.

Each VM is configured with:

- 2 CPU cores
- 4GB RAM
- 65GB disk
- RDP enabled on port 3389
- UEFI Secure Boot
- TPM support
- Hyper-V enlightenments

The VM configurations are defined in YAML files under the `vms/` directory.
