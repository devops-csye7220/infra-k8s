# Part 3 - Kubernetes Infrastructure 

- Terraform 
    - Amazon Web Services
    - Google Cloud Platform

- Ansible
    - Kube Context on Jenkins
    - Metric Components

## AWS Terraform

To setup a cluster on AWS, set the AWS profile to point to the AWS account config/credentials on the local system and run the terraform scripts `init, plan and apply` inside the `infra/aws` folder. See the following command to setup the kube config and point it to current context.

```bash
export AWS_PROFILE=root

terraform apply

aws eks --region us-east-1 update-kubeconfig --name eks-csye7220-devops --alias eks-csye7220-devops
```

## GCP Terraform

To setup a cluster on GCP, update the `tfvars` with correct values of `project_id` and `service_account`. Download a copy of the `service_account_credentials.json` inside the `infra/gcp` folder. Run the terraform scripts `init, plan and apply` inside the `infra/gcp` folder. See the following command to setup the kube config and point it to current context.

```bash

gcloud config set project csye7220-311817

gcloud container clusters get-credentials gke-csye7220-devops --region us-east4
```

### Bastion to Localhost

Connect to the Bastion Host of the cluster.

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

After the cluster has been setup and the nodes are available. Run the below ansible playbooks to transfer the kube context to jenkins server.

### Kube config Setup

Before running the below playbook, set the correct values of `local_kube_dir` and `local_aws_dir` in the `extra_vars.json` fiel to point to the correct path of `.kube` folder containing information of the cluster config and also, the `.aws` directory which contains the config/credentials of AWS account.

Additionaly, set the correct path of the `--private-key` to point to the `SSH key` on the AWS account.

```bash
ansible-playbook jenkins-kube-context-setup/setup-kube.yml --private-key "~/.ssh/aws-mac"  -i hosts --extra-vars "@extra_vars.json" -vvv
```

###  Metrics Components

To setup metric server and components, run the below playbook after setting the current context to `AWS cluster`.

```bash
ansible-playbook metric-components-setup/setup-metric-components.yml -vvv
```

#### Logging

- Access Kibana in AWS by port forwarding the service in the `logging` namespace.

```bash
k port-forward svc/efk-kibana 5601:5601 -n logging
```

#### Metrics

- Access Prometheus by port forwarding the service in the `metrics` namespace.

```bash
k port-forward svc/prometheus-server 8084:80 -n metrics
```

- Access Grafana by port forwarding the service in the `metrics` namespace.

```bash
k port-forward svc/grafana 8083:80 -n metrics
```
