output "bastion_network_ip" {
  value       = google_compute_instance.bastion.network_interface.0.network_ip
  description = "The IP address of the Bastion instance."
}