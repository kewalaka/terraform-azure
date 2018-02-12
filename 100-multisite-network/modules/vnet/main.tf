#
# Operational Network
#
module "operationalvnet" {
  source              = "git::git@github.com:kewalaka/terraform-azurerm-network.git"
  vnet_name           = "operationalvnet"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  address_space       = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["websubnet", "bizsubnet", "datasubnet"]
  tags                = "${var.tags}"
}

#
# Management Network
#
module "mgmtvnet" {
  source              = "git::git@github.com:kewalaka/terraform-azurerm-network.git"
  vnet_name           = "mgmtvnet"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  address_space       = "10.1.0.0/24"
  subnet_prefixes     = ["10.1.0.0/27"]
  subnet_names        = ["mgmtsubnet"]
  tags                = "${var.tags}"  
}


resource "azurerm_virtual_network_peering" "peerToOps" {
  name                         = "mgmtvnet-to-operationalvnet"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  virtual_network_name         = "${module.operationalvnet.vnet_name}"
  remote_virtual_network_id    = "${module.operationalvnet.vnet_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
}
