packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "win10" {
  iso_url               = "/home/hernan/Win10_22H2_English_x64v1.iso"
  iso_checksum          = "sha256:a6f470ca6d331eb353b815c043e327a347f594f37ff525f17764738fe812852e"
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
    ["-netdev", "user,id=net0,hostfwd=tcp::2240-:5985"],  
    ["-drive", "if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.secboot.fd"],
    ["-drive", "if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS_4M.ms.fd"],
    ["-drive", "file=/home/hernan/Win10_22H2_English_x64v1.iso,media=cdrom"],
    ["-drive", "file=/home/hernan/virtio-win.iso,media=cdrom"],
    ["-drive", "file=/home/hernan/packer/output-win10/windows10-disk.qcow2,if=virtio,cache=writeback,discard=ignore,format=qcow2"],
    ["-boot", "order=d"]
  ]

  # Networking
  net_device           = "virtio-net"

  # WinRM for Automation
  communicator         = "winrm"
  winrm_username       = "admin"
  winrm_password       = "test"
  winrm_timeout        = "90m"
  winrm_port           = "5985"

  # Shutdown Command
  shutdown_command     = "shutdown /s /t 10 /f"
}

build {
  sources = ["source.qemu.win10"]
}
