variable "project_id" {
  type = string
  description = "The project ID to host the network in"
}

variable "region" {
  type = string
  description = "The region to use"
}

variable "zone" {
  type = string
  description = "The zone to use"
}

variable "network" {
}

variable "subnet" {
}

variable "bastion_network_ip" {
  type = string
}

variable "service_account" {
  type = string
  description = "The service account to use"
}

variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.18.17-gke.700"
}

variable "service_account_roles" {
  description = "Additional roles to be added to the service account."
  type        = list(string)
  default     = []
}

variable "master_ipv4_cidr_block" {
  type = string
  description = "The /28 CIDR block to use for the master IPs"
  default     = "" # "172.16.0.16/28"
}

variable "master_authorized_networks_config" {
  description = <<EOF
  The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)
  ### example format ###
  master_authorized_networks_config = [{
    cidr_blocks = [{
      cidr_block   = "10.0.0.0/8"
      display_name = "External Control Plane access"
    }],
  }]
EOF
  type        = list(any)
  default     = []
}