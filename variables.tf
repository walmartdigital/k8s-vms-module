variable "cluster_name" {
  type    = "string"
  default = "kubernetes"
}

variable "environment" {
  type    = "string"
  default = "labs"
}

variable "main_resource_group" {
  type = "string"
}

variable "images_resource_group" {
  type = "string"
}

variable "root_domain" {
  type = "string"
}

variable "root_domain_resource_group" {
  type = "string"
}

variable "k8s_image_name" {
  type = "string"
}

variable "bastion_image_name" {
  type = "string"
}

variable "ssh_public_key" {
  type = "string"
}

variable "default_tags" {
  type = "map"

  default = {
    applicationname      = "k8s"
    deploymenttype       = "Terraform"
    platform             = "Kubernetes"
  }
}

variable "worker_count" {
  type    = "string"
  default = "3"
}
