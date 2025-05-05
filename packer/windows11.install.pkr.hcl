packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "win11" {
  iso_url               = "/home/hernan/Win11_24H2_English_x64.iso"
  iso_checksum          = "sha256:b56b911bf18a2ceaeb3904d87e7c770bdf92d3099599d61ac2497b91bf190b11"
  #output_directory      = "/home/hernan/packer/output-win11"
  format                = "qcow2"

  # QEMU Binary Path (For Windows)
  qemu_binary           = "/usr/bin/qemu-system-x86_64"

  # Machine Settings
  disk_size             = "50000"
  disk_interface        = "virtio"
  memory                = "8192"
  cpus                  = "4"

  # UEFI Support
  firmware              = "/usr/share/OVMF/OVMF_CODE_4M.secboot.fd"

  qemuargs = [
    ["-machine", "q35,accel=kvm"],  
    ["-cpu", "host"],  
    ["-display", "vnc=:0"],  
    ["-device", "virtio-net,netdev=net0"],  
    ["-netdev", "user,id=net0"],  
    ["-chardev", "socket,id=chrtpm,path=/tmp/mytpm1/swtpm-sock"],
    ["-tpmdev", "emulator,id=tpm0,chardev=chrtpm"],
    ["-device", "tpm-tis,tpmdev=tpm0"],
    ["-drive", "if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.secboot.fd"],
    ["-drive", "if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS_4M.ms.fd"],
    ["-drive", "file=/home/hernan/Win11_24H2_English_x64.iso,media=cdrom"],
    ["-drive", "file=/home/hernan/virtio-win.iso,media=cdrom"],
    ["-drive", "file=/home/hernan/packer/output-win11/windows11-disk.qcow2,if=virtio,cache=writeback,discard=ignore,format=qcow2"],
    ["-boot", "order=d"]
  ]

  # Networking
  net_device           = "virtio-net"

  # WinRM for Automation
  communicator         = "winrm"
  winrm_username       = "admin"
  winrm_password       = "test"
  winrm_timeout        = "90m"

  # Shutdown Command
  shutdown_command     = "shutdown /s /t 10 /f"
}

build {
  sources = ["source.qemu.win11"]
}
