# Kubernetes Virtual Machines Module

This module create all required resources for deploy a Virtual Machines to host a kubernetes cluster using
RKE (Rancher Kubernetes Engine).

## Usage

```bash
module "az_vms" {
  source = "git::https://github.com/walmartdigital/k8s-vms-module.git?ref=0.2.2"

  name_suffix               = "abc123"
  cluster_name              = "my-cluster"
  environment               = "staging"
  main_resource_group       = "my-resource-group"
  vnet_name                 = "my-vnet-name"
  subnet_name               = "my-subnet-name"
  images_resource_group     = "my-images-resource-group"
  k8s_image_name            = "k8s-v1.0.0"
  bastion_image_name        = "bastion-v1.0.0"
  ssh_public_key            = "abc123"
  worker_count              = "2"
  network_security_group_id = "network-security-group-id"
  lb_address_pool_id        = "loadbalancer-address-pool-id"
  worker_vm_size            = "my-worker-vm-size"
  worker_disk_size_gb       = "my-worker-disk-size_gb"
  manager_vm_size           = "my-manager-vm-size"
}
```

## Arguments

- **main_resource_group**: A string representing the resource group where all resources will be provisioned, this resource group needs to be previously created (required).
- **environment**: A string used as environment where the cluster is deployed (required).
- **name_suffix**: A string used as name suffix (required).
- **cluster_name**: A string used as the cluster name (required).
- **vnet_name**: A string representing the resource group virtual network (required).
- **subnet_name**: A string representing the subnet associated to virtual network (required).
- **images_resource_group**: A string representing the resource group where to find the custom images (required).
- **k8s_image_name**: A string used as custom k8s image name (required).
- **bastion_image_name**: A string used as custom bastion image name (required).
- **ssh_public_key**: A string used as the public ssh key for connect to bastion (required).
- **managert_count**: A string used as number of managers (default: 3).
- **worker_count**: A string used as number of workers (default: 3).
- **network_security_group_id**: A string used as network security group ID.
- **lb_address_pool_id**: A string used as load balancer address pool ID.
- **default_tags**: Tags assigned to every resource that support it (type: map).
- **worker_vm_size**: A string used to assign a custom azure vm size configuration for workers.
- **worker_disk_size_gb**: A string used to assign a custom azure disk size configuration for workers (default: 30gb).
- **manager_vm_size**: A string used to assign a custom azure vm size configuration for managers.
- **create_bastion**: "no" if you don't want to create bastion (default: "yes").
- **create_managers**: "no" if you don't want to create managers (default: "yes").

## Outputs

- **bastion_public_ip**: The bastion public IP address.
- **bastion_private_ip**: The bastion private IP address.
- **worker_ips**: The private IPs of the created worker VMs.
- **manager_ips**: The private IPs of the created manager VMs.

> You can use our [k8s-lb-module](https://github.com/walmartdigital/k8s-nsg-module) and [k8s-nsg-module](https://github.com/walmartdigital/k8s-nsg-module) to configure and use a Load Balancer and Network Security Group 100% compatible with this module
