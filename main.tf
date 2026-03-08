data "hcloud_image" "talos" {
  with_selector     = "type=talos,version=${var.talos_version}"
  most_recent       = true
  with_architecture = "x86"
}

resource "hcloud_placement_group" "control_plane" {
  name = "${var.cluster_name}-cp"
  type = "spread"
}

resource "hcloud_placement_group" "worker" {
  name = "${var.cluster_name}-worker"
  type = "spread"
}

resource "hcloud_network" "cluster" {
  name     = var.cluster_name
  ip_range = var.network_cidr
}

resource "hcloud_network_subnet" "nodes" {
  network_id   = hcloud_network.cluster.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.node_subnet_cidr
}

resource "hcloud_firewall" "cluster" {
  name = var.cluster_name

  # Talos apid
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "50000"
    source_ips = var.admin_cidrs
  }

  # ICMP
  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "control_plane" {
  count              = var.control_plane_count
  name               = "${var.cluster_name}-cp-${count.index}"
  server_type        = var.server_type
  location           = var.location
  image              = data.hcloud_image.talos.id
  placement_group_id = hcloud_placement_group.control_plane.id
  firewall_ids       = [hcloud_firewall.cluster.id]

  network {
    network_id = hcloud_network.cluster.id
  }

  depends_on = [hcloud_network_subnet.nodes]

  labels = {
    cluster = var.cluster_name
    role    = "control-plane"
  }

  lifecycle {
    ignore_changes = [network]
  }
}

resource "hcloud_server" "worker" {
  count              = var.worker_count
  name               = "${var.cluster_name}-worker-${count.index}"
  server_type        = var.server_type
  location           = var.location
  image              = data.hcloud_image.talos.id
  placement_group_id = hcloud_placement_group.worker.id
  firewall_ids       = [hcloud_firewall.cluster.id]

  network {
    network_id = hcloud_network.cluster.id
  }

  depends_on = [hcloud_network_subnet.nodes]

  labels = {
    cluster = var.cluster_name
    role    = "worker"
  }

  lifecycle {
    ignore_changes = [network]
  }
}
