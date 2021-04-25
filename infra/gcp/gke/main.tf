locals {
  all_service_account_roles = concat(var.service_account_roles, [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])
}

resource "google_project_iam_member" "service_account-roles" {
  for_each = toset(local.all_service_account_roles)
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${var.service_account}"
}

resource "google_container_cluster" "app_cluster" {
  provider = "google-beta"

  name     = "${var.project_id}-gke"
  location = var.region
  min_master_version = var.k8s_version
  remove_default_node_pool = true
  initial_node_count       = 1

  network = var.network.self_link
  subnetwork = var.subnet.self_link
  networking_mode = "VPC_NATIVE"

  dynamic "node_config" {
    for_each = [
      for x in [var.service_account] : x if var.service_account != null
    ]

    content {
      service_account = node_config.value
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.subnet.secondary_ip_range.0.range_name
    services_secondary_range_name = var.subnet.secondary_ip_range.1.range_name
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = false 
    # master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }
  }

  network_policy {
    enabled = "true"
    provider = "CALICO"
  }

  master_auth {
	  username = ""
	  password = ""

	  client_certificate_config {
      issue_client_certificate = false
    }
  }

  # master_authorized_networks_config {
  #   cidr_blocks {
  #     display_name = "bastion"
  #     cidr_block   = "10.0.0.0/8" # format("%s/32", var.bastion_network_ip)
  #   }
  # }

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = lookup(master_authorized_networks_config.value, "cidr_blocks", [])
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = lookup(cidr_blocks.value, "display_name", null)
        }
      }
    }
  }

  workload_identity_config {
    identity_namespace = format("%s.svc.id.goog", var.project_id)
  }
}

# Node Pool
resource "google_container_node_pool" "app_cluster_linux_node_pool" {
  provider = "google-beta"

  name           = "${google_container_cluster.app_cluster.name}-node-pool"
  location       = google_container_cluster.app_cluster.location
  cluster        = google_container_cluster.app_cluster.name
  node_count     = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    image_type   = "COS"
    machine_type = "e2-standard-4" # "n1-standard-1"  # e2-medium, e2-standard-4

    disk_size_gb = 20
    disk_type    = "pd-standard"

    labels = {
      env = var.project_id
    }

    tags = ["gke-node", "${var.project_id}-gke"]

    service_account = var.service_account

    metadata = {
      disable-legacy-endpoints = "true"
    }

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}
