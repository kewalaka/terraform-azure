#
# Operations
#
resource "azurerm_virtual_network" "operationalvnet" {
  name                = "${azurerm_resource_group.rg.name}operationalvnet"
  location            = "${var.location-site1}"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "appgwsubnet" {
  name                 = "appgwsubnet"
  virtual_network_name = "${azurerm_virtual_network.operationalvnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "10.0.4.0/24"
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

#
# Application Gateway
#
# Public IP
resource "azurerm_public_ip" "appgw-pip" {
  name                         = "appgw-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"
}

# Create an application gateway
resource "azurerm_application_gateway" "appgw" {
  name                = "appgw"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"

  sku {
    name           = "Standard_Small"
    tier           = "Standard"
    capacity       = 2
  }

  gateway_ip_configuration {
      name         = "my-gateway-ip-configuration"
      subnet_id    = "${azurerm_virtual_network.operationalvnet.id}/subnets/${azurerm_subnet.appgwsubnet.name}"
  }

  frontend_port {
      name         = "${azurerm_virtual_network.operationalvnet.name}-feport"
      port         = 80
  }

  frontend_ip_configuration {
      name         = "${azurerm_virtual_network.operationalvnet.name}-feip"  
      public_ip_address_id = "${azurerm_public_ip.appgw-pip.id}"
  }

  backend_address_pool {
      name = "${azurerm_virtual_network.operationalvnet.name}-beap"
  }

  backend_http_settings {
      name                  = "${azurerm_virtual_network.operationalvnet.name}-be-htst"
      cookie_based_affinity = "Disabled"
      port                  = 80
      protocol              = "Http"
     request_timeout        = 1
  }

  http_listener {
        name                                  = "${azurerm_virtual_network.operationalvnet.name}-httplstn"
        frontend_ip_configuration_name        = "${azurerm_virtual_network.operationalvnet.name}-feip"
        frontend_port_name                    = "${azurerm_virtual_network.operationalvnet.name}-feport"
        protocol                              = "Http"
  }

  request_routing_rule {
          name                       = "${azurerm_virtual_network.operationalvnet.name}-rqrt"
          rule_type                  = "Basic"
          http_listener_name         = "${azurerm_virtual_network.operationalvnet.name}-httplstn"
          backend_address_pool_name  = "${azurerm_virtual_network.operationalvnet.name}-beap"
          backend_http_settings_name = "${azurerm_virtual_network.operationalvnet.name}-be-htst"
  }
}