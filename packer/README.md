# Windows VM Packer Configurations

This directory contains Packer configurations for building Windows VM images using QEMU/KVM.

## Available Configurations

- `windows10.install.pkr.hcl` - Windows 10 22H2 image
- `windows11.install.pkr.hcl` - Windows 11 24H2 image
- `windows2019.install.pkr.hcl` - Windows Server 2019 image
- `windows2022.install.pkr.hcl` - Windows Server 2022 image

## Common Configuration

All VM images are configured with:

- QEMU/KVM virtualization
- VirtIO drivers for networking and storage
- UEFI Secure Boot support
- 8GB RAM and 4 CPU cores for build
- 50GB disk size
- WinRM for automation
- VNC display

# Setup packer development environment on Ubuntu and first Win11 build

### Get an Intel/AMD x84_64 machine with Ubuntu (latest) installed

## Software Installation:

```
sudo apt update && sudo apt upgrade -y
sudo apt install -y vim git curl qemu-system-x86 qemu-utils libvirt-daemon-system \
  libvirt-clients bridge-utils virtinst cloud-image-utils \
  genisoimage ovmf swtpm net-tools nfs-common
```

    •	qemu-system-x86 → QEMU virtualization for x86 architecture.
    •	qemu-utils → Utility tools for QEMU (e.g., qemu-img).
    •	libvirt-daemon-system → Required for managing virtual machines.
    •	libvirt-clients → CLI tools for managing virtual machines.
    •	bridge-utils → Allows network bridging.
    •	virtinst → Tools for creating VMs.
    •	cloud-image-utils → Used for cloud-init configurations.
    •	genisoimage → Creates ISOs for unattended installation.
    •	ovmf → UEFI firmware required for Windows 11.
    •	swtpm → Software TPM for Windows 11 compatibility.

## Enable and start services:

```
sudo systemctl enable --now libvirtd
sudo systemctl restart libvirtd
```

### Check KVM support:

```
kvm-ok
```

### Add user to groups:

```
sudo usermod -aG kvm,libvirt $(whoami)
newgrp kvm
newgrp libvirt
```

## Install packer:

```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

```
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

```
sudo apt update
sudo apt install -y packer
```

## To run swtpm for QEMU with TPM 2.0 support, you can use the following command:

```
swtpm socket --tpm2 --tpmstate dir=/tmp/mytpm1 --ctrl type=unixio,path=/tmp/mytpm1/swtpm-sock --log level=2
```

    •	socket → Starts swtpm in socket mode.
    •	--tpm2 → Enables TPM 2.0 mode.
    •	--tpmstate dir=/tmp/mytpm1 → Specifies the directory where TPM state is stored.
    •	--ctrl type=unixio,path=/tmp/mytpm1/swtpm-sock → Defines the control socket for communication with QEMU.
    •	--log level=2 → Sets the logging level for debugging.

## Fix Firmware permissions:

```
sudo chown $USER:$USER /usr/share/OVMF/*
```

## Enable VNC ports on Firewall:

```
sudo ufw allow 5900:5990/tcp
sudo ufw status
```

# Windows 11 Installation:

Since we don't have community built windows images, we need to build it by ourselves.
Follow the next steps to get a very first base image.

## SSH into the ubuntu machine:

IP: 192.168.1.141
User: hernan
Password: find this on 1password

## In the home folder for hernan user you should cd into the folder:

```
cd /home/hernan/homelab/packer
```

## Pull the latest code:

```
git pull
```

## Create qemu disk:

```
mkdir -p /home/hernan/packer/output-win11
qemu-img create -f qcow2 /home/hernan/packer/output-win11/windows11-disk.qcow2 50G
```

## To run packer build:

```
packer init windows11.install.pkr.hcl
packer build windows11.install.pkr.hcl
```

You can VNC into the machine using any VNC client using the IP from the server above.

### Notes: When running the installation, you may need to add drivers for Disk and Network, these are already present via ISO attached as cdrom. You can find them by clicking on Load driver button.
