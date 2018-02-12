#
# Operations
#
resource "azurerm_virtual_network" "operationalvnet" {
  name                = "${azurerm_resource_group.rg.name}operationalvnet"
  location            = "${var.location-site1}"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "datasubnet" {
  name                 = "datasubnet"
  virtual_network_name = "${azurerm_virtual_network.operationalvnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "10.0.3.0/24"
}

resource "azurerm_subnet" "bizsubnet" {
  name                 = "bizsubnet"
  virtual_network_name = "${azurerm_virtual_network.operationalvnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet" "websubnet" {
  name                 = "websubnet"
  virtual_network_name = "${azurerm_virtual_network.operationalvnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "10.0.1.0/24"
}

#
# Management
#
resource "azurerm_virtual_network" "mgmtvnet" {
  name                = "${azurerm_resource_group.rg.name}mgmtvnet"
  location            = "${var.location-site1}"
  address_space       = ["10.1.0.0/24"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_virtual_network_peering" "peerToOps" {
  name                         = "mgmtvnet-to-operationalvnet"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  virtual_network_name         = "${azurerm_virtual_network.mgmtvnet.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.operationalvnet.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
}
