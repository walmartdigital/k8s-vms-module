output "bastion_ip" {
  value = "${azurerm_public_ip.bastion.ip_address}"
}
output "worker_ips" {
  value = "${join(",", azurerm_network_interface.worker.*.private_ip_address)}"
}

output "manager_ips" {
  value = "${join(",", azurerm_network_interface.manager.*.private_ip_address)}"
}
