output "worker_ips" {
  value = "${join(",", azurerm_network_interface.worker.*.private_ip_address)}"
}

output "manager_ips" {
  value = "${join(",", azurerm_network_interface.manager.*.private_ip_address)}"
}
