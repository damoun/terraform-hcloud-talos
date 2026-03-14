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
# Example, should give the user an idea about how to use this module.
# This code is found in the examples directory.
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | ~> 1.60 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_cidrs"></a> [admin\_cidrs](#input\_admin\_cidrs) | CIDRs allowed to reach Talos endpoints | `list(string)` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `"talos-cluster"` | no |
| <a name="input_control_plane_count"></a> [control\_plane\_count](#input\_control\_plane\_count) | n/a | `number` | `3` | no |
| <a name="input_enable_load_balancer"></a> [enable\_load\_balancer](#input\_enable\_load\_balancer) | n/a | `bool` | `false` | no |
| <a name="input_enable_public_ipv4"></a> [enable\_public\_ipv4](#input\_enable\_public\_ipv4) | n/a | `bool` | `true` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | n/a | `string` | `"lb11"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"fsn1"` | no |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | n/a | `string` | `"172.16.16.0/20"` | no |
| <a name="input_node_subnet_cidr"></a> [node\_subnet\_cidr](#input\_node\_subnet\_cidr) | n/a | `string` | `"172.16.16.0/24"` | no |
| <a name="input_server_type"></a> [server\_type](#input\_server\_type) | n/a | `string` | `"cx23"` | no |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | n/a | `string` | `"v1.12.4"` | no |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | n/a | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_control_plane_internal_ips"></a> [control\_plane\_internal\_ips](#output\_control\_plane\_internal\_ips) | n/a |
| <a name="output_control_plane_ips"></a> [control\_plane\_ips](#output\_control\_plane\_ips) | n/a |
| <a name="output_control_plane_ipv6s"></a> [control\_plane\_ipv6s](#output\_control\_plane\_ipv6s) | n/a |
| <a name="output_load_balancer_ipv4"></a> [load\_balancer\_ipv4](#output\_load\_balancer\_ipv4) | n/a |
| <a name="output_load_balancer_ipv6"></a> [load\_balancer\_ipv6](#output\_load\_balancer\_ipv6) | n/a |
| <a name="output_worker_internal_ips"></a> [worker\_internal\_ips](#output\_worker\_internal\_ips) | n/a |
| <a name="output_worker_ips"></a> [worker\_ips](#output\_worker\_ips) | n/a |
| <a name="output_worker_ipv6s"></a> [worker\_ipv6s](#output\_worker\_ipv6s) | n/a |

## Resources

| Name | Type |
|------|------|
| hcloud_firewall.cluster | resource |
| hcloud_load_balancer.api | resource |
| hcloud_load_balancer_network.api | resource |
| hcloud_load_balancer_service.api | resource |
| hcloud_load_balancer_target.control_plane | resource |
| hcloud_network.cluster | resource |
| hcloud_network_subnet.nodes | resource |
| hcloud_placement_group.control_plane | resource |
| hcloud_placement_group.worker | resource |
| hcloud_server.control_plane | resource |
| hcloud_server.worker | resource |
| hcloud_image.talos | data source |
<!-- END_TF_DOCS -->
