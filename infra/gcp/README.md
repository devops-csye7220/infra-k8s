# Terraform GCP setup with a private GKE cluster

gcloud auth list

gcloud info

gcloud auth application-default login

gcloud config get-value project

tf plan 

Enable Compute Engine API, Kubernetes Engine API

tf apply

gcloud config set project csye7220-311301
gcloud config set project csye7220-311817

gcloud container clusters get-credentials csye7220-311301-gke  --region us-east4
gcloud container clusters get-credentials csye7220-311817-gke  --region us-east4

# Bastion to Localhost

gcloud beta compute ssh "csye7220-311817-bastion" --tunnel-through-iap --project "csye7220-311817" --zone "us-east4-b" -- -L8888:127.0.0.1:8888

# Portforward master from bastion to local

gcloud beta compute ssh "csye7220-311817-bastion" --tunnel-through-iap --project "csye7220-311817" --zone "us-east4-b" -- -L8888:10.0.0.35:22

# SSH to localhost

ssh -i ~/.ssh/google_compute_engine localhost -p 8888

# Postgres Connection

gcloud sql connect terraform-20210413163756713400000001 --user=postgres --quiet

psql -h 10.63.0.3 -p 5432 -U postgres csye7220_webapp
