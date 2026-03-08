<h1 align="center">
  terraform-hcloud-talos
  <br>
</h1>

<h4 align="center">A Terraform/OpenTofu module to provision a Talos Linux cluster on Hetzner Cloud.</h4>

<p align="center">
  <a href="#workflow">Workflow</a> •
  <a href="#requirements">Requirements</a> •
  <a href="#example">Example</a> •
  <a href="#providers">Providers</a> •
  <a href="#inputs">Inputs</a> •
  <a href="#outputs">Outputs</a> •
  <a href="#resources">Resources</a> •
</p>

## Workflow

This module follows a two-step provisioning flow:

1. **Packer builds a Talos snapshot** (`packer/talos.pkr.hcl`):
   - Downloads the Talos disk image from `factory.talos.dev`
   - Creates a Hetzner Cloud snapshot labeled `type=talos,version=<talos_version>`

2. **Terraform looks up the snapshot** by those labels and provisions the cluster:
   - `data.hcloud_image.talos` — finds the snapshot via `type=talos,version=<talos_version>`
   - Creates network, firewall, placement groups, and servers

Run Packer first, then Terraform.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | ~> 1.60 |

## Example

```hcl
module "hetzner" {
  source = "git::https://github.com/damoun/terraform-hcloud-talos.git?ref=main"

  hcloud_token        = var.hcloud_token
  cluster_name        = "my-cluster"
  talos_version       = "v1.12.4"
  control_plane_count = 3
  worker_count        = 3
  admin_cidrs         = ["0.0.0.0/0"]
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | ~> 1.60 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | Hetzner Cloud API token | `string` | n/a | yes |
| <a name="input_admin_cidrs"></a> [admin\_cidrs](#input\_admin\_cidrs) | CIDRs allowed to reach Talos endpoints | `list(string)` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster name | `string` | `"talos-cluster"` | no |
| <a name="input_location"></a> [location](#input\_location) | Hetzner location | `string` | `"fsn1"` | no |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | Talos version (must match a snapshot built by Packer) | `string` | `"v1.12.4"` | no |
| <a name="input_server_type"></a> [server\_type](#input\_server\_type) | Hetzner server type | `string` | `"cx23"` | no |
| <a name="input_control_plane_count"></a> [control\_plane\_count](#input\_control\_plane\_count) | Number of control plane nodes | `number` | `3` | no |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | Number of worker nodes | `number` | `3` | no |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | Network CIDR | `string` | `"172.16.16.0/20"` | no |
| <a name="input_node_subnet_cidr"></a> [node\_subnet\_cidr](#input\_node\_subnet\_cidr) | Node subnet CIDR | `string` | `"172.16.16.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_control_plane_ips"></a> [control\_plane\_ips](#output\_control\_plane\_ips) | Public IPv4 addresses of control plane nodes |
| <a name="output_worker_ips"></a> [worker\_ips](#output\_worker\_ips) | Public IPv4 addresses of worker nodes |

## Resources

| Name | Type |
|------|------|
| [hcloud_firewall.cluster](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall) | resource |
| [hcloud_network.cluster](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network) | resource |
| [hcloud_network_subnet.nodes](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_subnet) | resource |
| [hcloud_placement_group.control_plane](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/placement_group) | resource |
| [hcloud_placement_group.worker](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/placement_group) | resource |
| [hcloud_server.control_plane](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [hcloud_server.worker](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [hcloud_image.talos](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/data-sources/image) | data source |
<!-- END_TF_DOCS -->
