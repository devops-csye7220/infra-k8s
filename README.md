#  Kubernetes Infrastructure 

## K8s Kube config Setup

```bash
ansible-playbook jenkins-kube-context-setup/setup-kube.yml --private-key "~/.ssh/aws-mac"  -i hosts --extra-vars "@extra_vars-local.json" -vvv
```
