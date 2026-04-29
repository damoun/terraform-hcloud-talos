terraform {
  required_version = "1.14.8"

  required_providers {
    hcloud = {
      source  = "registry.opentofu.org/hetznercloud/hcloud"
      version = "1.60.1"
    }
  }
}
