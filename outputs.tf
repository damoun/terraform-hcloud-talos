output "control_plane_ips" {
  value = [for s in hcloud_server.control_plane : s.ipv4_address]
}

output "worker_ips" {
  value = [for s in hcloud_server.worker : s.ipv4_address]
}

output "load_balancer_ipv4" {
  value = var.enable_load_balancer ? hcloud_load_balancer.api[0].ipv4 : null
}

output "load_balancer_ipv6" {
  value = var.enable_load_balancer ? hcloud_load_balancer.api[0].ipv6 : null
}
