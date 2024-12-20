module "k3s_cluster" {
  source            = "github.com/CBX0N/proxmox-create-k3s-cluster?ref=v1.0.6"
  master_node_vm_config = var.master_node_vm_config
  agent_node_vm_config = var.agent_node_vm_config
  cluster_config = {
    primary_service_run_command     = var.cluster_config.primary_service_run_command
    secondaries_service_run_command = var.cluster_config.secondaries_service_run_command
    agents_service_run_command      = var.cluster_config.agents_service_run_command
    admin_user                      = var.cluster_config.admin_user
    admin_password                  = var.cluster_config.admin_password
    ssh_keys                        = [for key in var.cluster_config.ssh_keys : data.onepassword_item.cluster_ssh_keys["${key}"].public_key]
    packages                        = var.cluster_config.packages
    k3s_images_url                  = var.cluster_config.k3s_images_url
    k3s_bin_url                     = var.cluster_config.k3s_bin_url
    k3s_service_url                 = var.cluster_config.k3s_service_url
    vmname_prefix                   = var.cluster_config.vmname_prefix
    starting_vmid                   = var.cluster_config.starting_vmid
    nodes = var.cluster_config.nodes
  }
  proxmox_ssh_config = {
    ssh_user     = data.onepassword_item.proxmox_ssh.username
    ssh_password = data.onepassword_item.proxmox_ssh.password
    ssh_host     = data.onepassword_item.proxmox_ssh.url
  }
}

resource "onepassword_item" "kubeconfig" {
  depends_on = [module.k3s_cluster]
  vault      = var.onepassword_vault
  title      = "${var.environment}_kubeconfig"
  note_value = module.k3s_cluster.kubeconfig
}

resource "local_file" "kubeconfig" {
  depends_on = [module.k3s_cluster]
  content    = module.k3s_cluster.kubeconfig
  filename   = "/home/ansible/.kube/${var.environment}.yaml"
}

resource "time_sleep" "wait_5m" {
  depends_on      = [onepassword_item.kubeconfig]
  create_duration = "300s"
}

resource "flux_bootstrap_git" "repository" {
  depends_on         = [time_sleep.wait_5m, local_file.kubeconfig]
  embedded_manifests = true
  path               = "clusters/${var.environment}/"
  
}