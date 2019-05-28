resource "azurerm_dns_zone" "main" {
  name                = "aterraform.com"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_dns_a_record" "main" {
  name                = "dns_zone"
  zone_name           = "${azurerm_dns_zone.main.name}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  ttl                 = 300
  records             = ["10.0.170.18"]
}