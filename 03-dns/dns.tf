resource "azurerm_dns_zone" "kewalakanz_dns_zone" {
  name = "${var.dns_zone}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags {
    environment = "${var.tags["environment"]}"
    project = "${var.tags["project"]}"
  }   
}
#debug
output "kewalakanz_dns_zone name" {
  value = "${azurerm_dns_zone.kewalakanz_dns_zone.name}"
}