resource "azurerm_network_interface" "worker" {
  count                     = var.worker_count
  name                      = "${var.cluster_name}-${var.environment}-${var.name_suffix}-${format("${var.worker_name}%d", count.index + 1)}"
  location                  = data.azurerm_resource_group.main.location
  resource_group_name       = data.azurerm_resource_group.main.name
  network_security_group_id = var.worker_network_security_group_id
  enable_ip_forwarding      = true

  ip_configuration {
    name                          = "${var.cluster_name}-${var.environment}-${var.name_suffix}-${format("${var.worker_name}%d", count.index + 1)}"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "worker_public" {
  count                   = var.worker_count
  network_interface_id    = element(azurerm_network_interface.worker.*.id, count.index)
  ip_configuration_name   = "${var.cluster_name}-${var.environment}-${var.name_suffix}-${format("${var.worker_name}%d", count.index + 1)}"
  backend_address_pool_id = var.worker_lb_address_pool_id_public
}

resource "azurerm_network_interface_backend_address_pool_association" "worker_private" {
  count                   = var.worker_count
  network_interface_id    = element(azurerm_network_interface.worker.*.id, count.index)
  ip_configuration_name   = "${var.cluster_name}-${var.environment}-${var.name_suffix}-${format("${var.worker_name}%d", count.index + 1)}"
  backend_address_pool_id = var.worker_lb_address_pool_id_private
}

resource "azurerm_virtual_machine" "worker" {
  count                            = var.worker_count
  name                             = "${var.cluster_name}-${var.environment}-${var.name_suffix}-${format("${var.worker_name}%d", count.index + 1)}"
  location                         = data.azurerm_resource_group.main.location
  availability_set_id              = azurerm_availability_set.workers.id
  resource_group_name              = data.azurerm_resource_group.main.name
  network_interface_ids            = [element(azurerm_network_interface.worker.*.id, count.index)]
  vm_size                          = var.worker_vm_size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = data.azurerm_image.k8s.id
  }

  storage_os_disk {
    name              = "${var.cluster_name}-${var.environment}-${var.name_suffix}-${format("${var.worker_name}%d", count.index + 1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.worker_disk_size
  }

  os_profile {
    computer_name  = "${var.cluster_name}-${var.environment}-${var.name_suffix}-${format("${var.worker_name}%d", count.index + 1)}"
    admin_username = "ubuntu"
    admin_password = "ef208a6b-a6b0-47f0-be8f-2d2bd2e640ba"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  }

  tags = merge(
    var.default_tags,
    {
      "environmentinfo" = "T:Prod; N:${var.cluster_name}-${var.environment}-${var.name_suffix}"
      "cluster"         = "${var.cluster_name}-${var.environment}-${var.name_suffix}"
      "role"            = "worker"
    },
  )
}

