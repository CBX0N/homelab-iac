nodes = {
  "k3sprd01" = {
    type = "primary"
    vmid = 221
  }
  "k3sprd02" = {
    type = "secondary"
    vmid = 222
  }
  "k3sprd03" = {
    type = "secondary"
    vmid = 223
  }
}

proxmox_vm_config = {
  clone         = "ubuntu-noble-template"
  ip_gateway    = "192.168.0.1"
  ip_prefix     = "192.168.0"
  disk_location = "datastore1"
}

cluster_config = {
  primary_service_run_command     = "--cluster-init --write-kubeconfig-mode=0644"
  secondaries_service_run_command = "--server https:\\/\\/192.168.0.221:6443"
  admin_user                      = "ansible"
  ssh_keys                        = ["lab", "gitlab", "homelab"]
  packages                        = ["qemu-guest-agent", "containerd", "unzip", "nfs-common"]
  k3s_images_url                  = "https://github.com/k3s-io/k3s/releases/download/v1.29.1-rc2%2Bk3s1/k3s-airgap-images-amd64.tar.zst"
  k3s_bin_url                     = "https://github.com/k3s-io/k3s/releases/download/v1.30.0%2Bk3s1/k3s"
  k3s_service_url                 = "https://raw.githubusercontent.com/k3s-io/k3s/refs/heads/master/k3s.service"
}

onepassword_vault = "uadqgdescn34aubde6zusrehui"
onepassword_secrets = {
  proxmox_api  = "proxmox-api"
  proxmox_ssh  = "proxmox-ssh"
  github_token = "github_fluxcd_token"
}

github_org                   = "cbx0n"
github_repository            = "homelab-prd-fluxcd"
github_repository_visibility = "public"
