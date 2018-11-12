data "azurerm_resource_group" "root_domain" {
  name = "${var.root_domain_resource_group}"
}

data "azurerm_dns_zone" "root_domain" {
  name                = "${var.root_domain}"
  resource_group_name = "${data.azurerm_resource_group.root_domain.name}"
}

resource "azurerm_dns_zone" "subdomain" {
  name                = "${var.environment}-${random_string.id.result}.${data.azurerm_dns_zone.root_domain.name}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
}

resource "azurerm_dns_ns_record" "subdomain" {
  name                = "${var.environment}-${random_string.id.result}"
  zone_name           = "${data.azurerm_dns_zone.root_domain.name}"
  resource_group_name = "${data.azurerm_resource_group.root_domain.name}"
  ttl                 = 1
  records             = ["${azurerm_dns_zone.subdomain.name_servers}"]
}

resource "azurerm_dns_a_record" "bastion" {
  name                = "bastion"
  zone_name           = "${azurerm_dns_zone.subdomain.name}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  ttl                 = 1
  records             = ["${azurerm_public_ip.bastion.ip_address}"]
}
