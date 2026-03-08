output "control_plane_ips" {
  value = [for s in hcloud_server.control_plane : s.ipv4_address]
}

output "worker_ips" {
  value = [for s in hcloud_server.worker : s.ipv4_address]
}

output "load_balancer_ipv4" {
  value = hcloud_load_balancer.api.ipv4
}

output "load_balancer_ipv6" {
  value = hcloud_load_balancer.api.ipv6
}
