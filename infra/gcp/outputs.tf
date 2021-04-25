output "bastion_open_tunnel_command" {
  description = "Command that opens an SSH tunnel to the Bastion instance."
  value       = "gcloud beta compute ssh 'csye7220-311817-bastion' --tunnel-through-iap --project 'csye7220-311817' --zone 'us-east4-b' -- -L8888:127.0.0.1:8888"
}
