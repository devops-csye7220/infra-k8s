variable "project_id" {
  type = string
  description = "The ID of the project to create resources in"
}

variable "region" {
  type = string
  description = "The region to use"
}

variable "main_zone" {
  type = string
  description = "The zone to use as primary"
}

variable "credentials_file_path" {
  type = string
  description = "The credentials JSON file used to authenticate with GCP"
}

variable "service_account" {
  type = string
  description = "The GCP service account"
}

variable "project_services" {
  type = list

  default = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "iap.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "securetoken.googleapis.com",
    "stackdriver.googleapis.com",
    "sqladmin.googleapis.com"
  ]
  description = <<-EOF
  The GCP APIs that should be enabled in this project.
  EOF
}


