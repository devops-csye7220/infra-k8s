#  Kubernetes Infrastructure 

## Terraform

```bash
export AWS_PROFILE=root

tf apply

aws eks --region us-east-1 update-kubeconfig --name csye7220-devops-eks-RBuFsThi
```

## K8s Kube config Setup

```bash
ansible-playbook jenkins-kube-context-setup/setup-kube.yml --private-key "~/.ssh/aws-mac"  -i hosts --extra-vars "@extra_vars-local.json" -vvv
```
