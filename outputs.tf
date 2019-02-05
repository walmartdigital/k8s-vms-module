output "bastion_public_ip" {
  value = "${azurerm_public_ip.bastion.*.ip_address}"
}

output "bastion_private_ip" {
  value = "${azurerm_network_interface.bastion.*.private_ip_address}"
}

output "worker_ips" {
  value = "${join(",", azurerm_network_interface.worker.*.private_ip_address)}"
}

output "manager_ips" {
  value = "${join(",", azurerm_network_interface.manager.*.private_ip_address)}"
}
