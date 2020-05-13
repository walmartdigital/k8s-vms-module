resource "azurerm_public_ip" "bastion" {
  count               = var.add_bastion == "yes" ? "1" : "0"
  name                = "${var.cluster_name}-${var.environment}-${var.name_suffix}-bastion"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "bastion" {
  count               = var.add_bastion == "yes" ? "1" : "0"
  name                = "${var.cluster_name}-${var.environment}-${var.name_suffix}-bastion"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_network_security_rule" "ssh" {
  count                       = var.add_bastion == "yes" ? var.block_bastion_ssh == "yes" ? "1" : "0" : "0"
  name                        = "ssh"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.bastion[0].name
}

resource "azurerm_network_security_rule" "ssh_allowed_ips" {
  count                       = var.add_bastion == "yes" ? var.block_bastion_ssh == "yes" ? "0" : length(var.bastion_ssh_allowed_ips) : "0"
  name                        = "ssh${count.index}"
  priority                    = 150+count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.bastion_ssh_allowed_ips[count.index]
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.bastion[0].name
}

resource "azurerm_network_interface" "bastion" {
  count                     = var.add_bastion == "yes" ? "1" : "0"
  name                      = "${var.cluster_name}-${var.environment}-${var.name_suffix}-bastion"
  location                  = data.azurerm_resource_group.main.location
  resource_group_name       = data.azurerm_resource_group.main.name
  network_security_group_id = azurerm_network_security_group.bastion[0].id

  ip_configuration {
    name                          = "${var.cluster_name}-${var.environment}-${var.name_suffix}-bastion"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion[0].id
  }
}

resource "azurerm_virtual_machine" "bastion" {
  count                            = var.add_bastion == "yes" ? "1" : "0"
  name                             = "${var.cluster_name}-${var.environment}-${var.name_suffix}-bastion"
  location                         = data.azurerm_resource_group.main.location
  resource_group_name              = data.azurerm_resource_group.main.name
  network_interface_ids            = [azurerm_network_interface.bastion[0].id]
  vm_size                          = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = data.azurerm_image.bastion.id
  }

  storage_os_disk {
    name              = "${var.cluster_name}-${var.environment}-${var.name_suffix}-bastion"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.cluster_name}-${var.environment}-${data.azurerm_resource_group.main.location}"
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
      "role"            = "bastion"
    },
  )
}
