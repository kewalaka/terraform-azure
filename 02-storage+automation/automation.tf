resource "azurerm_automation_account" "automation" {
  name                = "kewalaka"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  sku {
    name = "Basic"
  }

  tags {
    environment = "${var.tags["environment"]}"
    project     = "${var.tags["project"]}"
  }
}

resource "azurerm_automation_credential" "automationcredential" {
  name                = "kewalakadomainadmin"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  account_name        = "${azurerm_automation_account.automation.name}"
  username            = "kewalaka"
  password            = "${var.kewalakapassword}"
  description         = "Domain admin account in this lab"
}