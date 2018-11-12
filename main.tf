resource "azurerm_availability_set" "nodes" {
  name                        = "${var.cluster_name}-${var.environment}-${random_string.id.result}-nodes"
  location                    = "${data.azurerm_resource_group.main.location}"
  resource_group_name         = "${data.azurerm_resource_group.main.name}"
  managed                     = true
  platform_fault_domain_count = 2
}

data "azurerm_resource_group" "main" {
  name = "${var.main_resource_group}"
}

data "azurerm_subnet" "subnet" {
  name                 = "cl-${var.environment}-primary"
  virtual_network_name = "cl-${var.environment}"
  resource_group_name  = "${data.azurerm_resource_group.main.name}"
}

data "azurerm_image" "k8s" {
  name                = "${var.k8s_image_name}"
  resource_group_name = "${var.images_resource_group}"
}

data "azurerm_image" "bastion" {
  name                = "${var.bastion_image_name}"
  resource_group_name = "${var.images_resource_group}"
}

resource "random_string" "id" {
  length  = 6
  lower   = true
  upper   = false
  number  = false
  special = false
}
