#  Kubernetes Infrastructure 

- Terraform 
    - Amazon Web Services
    - Google Cloud Platform

- Ansible
    - Kube Context on Jenkins
    - Metric Components

## AWS Terraform

```bash
export AWS_PROFILE=root

aws eks --region us-east-1 update-kubeconfig --name eks-csye7220-devops --alias eks-csye7220-devops
```

## GCP Terraform

```bash
gcloud config set project csye7220-311817

gcloud container clusters get-credentials gke-csye7220-devops --region us-east4
```

### Bastion to Localhost

```bash
gcloud beta compute ssh "csye7220-311817-bastion" --tunnel-through-iap --project "csye7220-311817" --zone "us-east4-b" -- -L8888:127.0.0.1:8888
```

### Portforward master from bastion to local

```bash
gcloud beta compute ssh "csye7220-311817-bastion" --tunnel-through-iap --project "csye7220-311817" --zone "us-east4-b" -- -L8888:10.0.0.35:22
```

### SSH to localhost

```bash
ssh -i ~/.ssh/google_compute_engine localhost -p 8888
```

## Ansible Playbook

### Kube config Setup

```bash
ansible-playbook jenkins-kube-context-setup/setup-kube.yml --private-key "~/.ssh/aws-mac"  -i hosts --extra-vars "@extra_vars-local.json" -vvv
```

###  Metrics Components

```bash
ansible-playbook metric-components-setup/setup-metric-components.yml -vvv
```

#### Logging

- Access Kibana in AWS 

```bash
k port-forward svc/efk-kibana 5601:5601 -n logging
```

#### Metrics

- Access Prometheus 

```bash
k port-forward svc/prometheus-server 8084:80 -n metrics
```

- Access Grafana 

```bash
k port-forward svc/grafana 8083:80 -n metrics
```
