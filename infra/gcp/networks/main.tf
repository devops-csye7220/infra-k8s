locals {
  network_name                   = "${var.project_id}-network"
  subnet_name                    = "${google_compute_network.vpc.name}-subnet"
}

resource "google_compute_network" "vpc" {
  name                            = local.network_name
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  name = local.subnet_name
  region  = var.region
  network = google_compute_network.vpc.self_link

  private_ip_google_access = true
  ip_cidr_range = "10.0.0.0/24"

  secondary_ip_range {
    range_name    = format("%s-gke-pod-range", var.project_id)
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = format("%s-gke-svc-range", var.project_id)
    ip_cidr_range = "10.2.0.0/20"
  }
}

resource "google_compute_firewall" "private_allow_all_network_inbound" {
  name = "${local.network_name}-private-allow-ingress"
  network = google_compute_network.vpc.self_link

  target_tags = ["private"]
  direction   = "INGRESS"

  source_ranges = [
    google_compute_subnetwork.subnet.ip_cidr_range,
    google_compute_subnetwork.subnet.secondary_ip_range.0.ip_cidr_range,
    google_compute_subnetwork.subnet.secondary_ip_range.1.ip_cidr_range
  ]

  priority = "1000"

  allow {
    protocol = "all"
  }
} 
