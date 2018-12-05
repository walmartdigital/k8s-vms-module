# Kubernetes Azure Module

This module create all required resources for deploy a kubernetes cluster using
rke (Rancher Kubernetes Engine).

## Usage

```bash
module "k8s" {
  source = "https://github.com/walmartdigital/k8s-azure-module.git?ref=0.0.1"

  name_suffix = "mysuffix"
  cluster_name = "my-cluster"
  environment = "staging"
  main_resource_group = "my-resource-group"
  k8s_image_name = "k8s-v1.0.0"
  bastion_image_name = "bastion-v1.0.0"
  images_resource_group = "my-images-resource-group"
  ssh_public_key = "abc123"
  worker_count = "2"
}
```

## Arguments

* **name_suffix**: Name of the suffix after the name (type: string).
* **cluster_name**: Name of the cluster (type: string, default: kubernetes).
* **environment**: Environment where the cluster is deployed (type: string, default: labs).
* **main_resource_group**: Resource group where all resources will be provisioned (type: string, required).
* **k8s_image_name**: Custom K8s image name (type: string, required).
* **bastion_image_name**: Custom bastion image name (type: string, required).
* **images_resource_group**: Resource group where to find the custom images (type: string, required).
* **ssh_public_key**: The public ssh key for connect to bastion (type: string, required).
* **default_tags**: Tags assigned to every resource that support it (type: map).
* **worker_count**: Number of workers (type: string, default: 3).

## Outputs

* **worker_ips**: The private IPs of the created worker VMs.
* **manager_ips**: The private IPs of the created manager VMs.
