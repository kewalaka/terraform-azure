provider "azurerm" {
  # if you're using a Service Principal (shared account) then either set the environment
  # variables, or fill these in:  # subscription_id = "..."  # client_id       = "..."  
  # client_secret   = "..."  # tenant_id       = "..."
  subscription_id = "${var.ARM_SUBSCRIPTION_ID}"
  tenant_id       = "${var.ARM_TENANT_ID}"
  client_id       = "${var.ARM_CLIENT_ID}"
  client_secret   = "${var.ARM_CLIENT_SECRET}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group}"
  location = "${var.location-site1}"
}
output "resource group project" {
    value = "${azurerm_resource_group.rg.name}"
}
