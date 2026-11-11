terraform {
  required_version = "1.17.1"

  required_providers {
    hcloud = {
      source  = "registry.opentofu.org/hetznercloud/hcloud"
      version = "1.70.2"
    }
  }
}
