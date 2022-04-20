source "vmware-iso" "jammy-daily" {
  // Docs: https://www.packer.io/plugins/builders/vmware/iso

  // VM Info:
  vm_name       = "jammy-2022-04-17"
  guest_os_type = "ubuntu64Guest"
  version       = "16"
  headless      = false
  // Virtual Hardware Specs
  memory        = 8172
  cpus          = 2
  cores         = 2
  disk_size     = 81920
  sound         = true
  disk_type_id  = 0
  
  // ISO Details
  iso_urls =[
          "file:/Users/bazbill/Downloads/jammy-live-server-amd64.iso",
          "https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/jammy-live-server-amd64.iso"]
  iso_checksum = "sha256:c02a89385c11ae5856b5c0b68b37aa838ae848659e89a302a687251ea004ee4f"
  iso_target_path   = "/Users/bazbill/Downloads"
  output_directory  = "/Users/bazbill/Downloads/Ubuntu-22.04-Build"
  snapshot_name     = "clean"  
  http_directory    = "http"
  ssh_username      = "vmadmin"
  ssh_password      = "MyP@ssw0rd-22!"
  shutdown_command  = "sudo shutdown -P now"

  boot_wait = "5s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]
}

build {
  sources = ["sources.vmware-iso.jammy-daily"]
}
