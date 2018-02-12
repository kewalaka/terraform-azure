resource "azurerm_storage_account" "sa" {
  name     = "${var.storage_account["name"]}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location = "${var.location-site1}"
  account_tier = "${var.storage_account["tier"]}"
  account_replication_type = "${var.storage_account["replicationtype"]}"
  enable_blob_encryption = true
  enable_file_encryption = true
  enable_https_traffic_only = true
  tags {
    environment = "${var.tags["environment"]}"
    project = "${var.tags["project"]}"
  }
}
output "storage account" {
    value = "${azurerm_storage_account.sa.name}"
}
