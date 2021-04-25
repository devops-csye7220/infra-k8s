
provider "google" {
  credentials = file(var.credentials_file_path)

  project = var.project_id
  region  = var.region
  zone    = var.main_zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.main_zone
}

resource "google_project_service" "service" {
  count   = length(var.project_services)
  project = var.project_id

  service = element(var.project_services, count.index)
  disable_on_destroy = false
}

module "google_networks" {
  source = "./networks"

  project_id = var.project_id
  region     = var.region
}

module "bastion" {
  source = "./bastion"

  project_id   = var.project_id
  region       = var.region
  zone         = var.main_zone
  bastion_name = "${var.project_id}-bastion"
  network_name = module.google_networks.network.name
  subnet_name  = module.google_networks.subnet.name

}

module "gke" {
  source = "./gke"

  project_id                 = var.project_id
  region                     = var.region
  zone                       = var.main_zone
  service_account            = var.service_account
  network                    = module.google_networks.network
  subnet                     = module.google_networks.subnet
  bastion_network_ip         = module.bastion.bastion_network_ip
}

