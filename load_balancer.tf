resource "hcloud_load_balancer" "api" {
  count              = var.enable_load_balancer ? 1 : 0
  name               = "${var.cluster_name}-api"
  load_balancer_type = var.load_balancer_type
  location           = var.location

  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_network" "api" {
  count            = var.enable_load_balancer ? 1 : 0
  load_balancer_id = hcloud_load_balancer.api[0].id
  network_id       = hcloud_network.cluster.id
}

resource "hcloud_load_balancer_service" "api" {
  count            = var.enable_load_balancer ? 1 : 0
  load_balancer_id = hcloud_load_balancer.api[0].id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443

  health_check {
    protocol = "tcp"
    port     = 6443
    interval = 10
    timeout  = 5
    retries  = 3
  }
}

resource "hcloud_load_balancer_target" "control_plane" {
  count            = var.enable_load_balancer ? var.control_plane_count : 0
  load_balancer_id = hcloud_load_balancer.api[0].id
  type             = "server"
  server_id        = hcloud_server.control_plane[count.index].id
  use_private_ip   = true

  depends_on = [hcloud_load_balancer_network.api]
}
