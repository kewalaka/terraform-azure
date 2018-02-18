output "resource group site1" {
    value = "${azurerm_resource_group.rg.name}"
}

output "storage account" {
    value = "${azurerm_storage_account.sa.name}"
}