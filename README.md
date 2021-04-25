#  Kubernetes Infrastructure 

## AWS Terraform

```bash
export AWS_PROFILE=root

tf apply

aws eks --region us-east-1 update-kubeconfig --name csye7220-devops-eks-RBuFsThi --alias csye7220-aws-cluster
```

## GCP Terraform

```bash
gcloud config set project csye7220-311817

gcloud container clusters get-credentials csye7220-311817-gke  --region us-east4
```

# Bastion to Localhost

gcloud beta compute ssh "csye7220-311817-bastion" --tunnel-through-iap --project "csye7220-311817" --zone "us-east4-b" -- -L8888:127.0.0.1:8888

# Portforward master from bastion to local

gcloud beta compute ssh "csye7220-311817-bastion" --tunnel-through-iap --project "csye7220-311817" --zone "us-east4-b" -- -L8888:10.0.0.35:22

# SSH to localhost

ssh -i ~/.ssh/google_compute_engine localhost -p 8888

## K8s Kube config Setup

```bash
ansible-playbook jenkins-kube-context-setup/setup-kube.yml --private-key "~/.ssh/aws-mac"  -i hosts --extra-vars "@extra_vars-local.json" -vvv
```

## K8s Metrics Components

```bash
ansible-playbook metric-components-setup/setup-metric-components.yml -vvv
```