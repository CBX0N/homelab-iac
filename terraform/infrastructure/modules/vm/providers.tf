terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

# provider "proxmox" {
#   pm_api_token_id     = var.pm_api_token_id
#   pm_api_token_secret = var.pm_api_token_secret
#   pm_api_url          = var.pm_api_url
# }