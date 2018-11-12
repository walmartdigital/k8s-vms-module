output "worker_ips" {
  value = "${join(",", azurerm_network_interface.worker.*.private_ip_address)}"
}

output "manager_ips" {
  value = "${join(",", azurerm_network_interface.manager.*.private_ip_address)}"
}

output "etcd_ips" {
  value = "${join(",", azurerm_network_interface.etcd.*.private_ip_address)}"
}

output "dns_zone_name" {
  value = "${azurerm_dns_zone.root.name}"
}

