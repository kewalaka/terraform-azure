# use terraform init to put down this provider
#     terraform plan to show what it will do
#     terraform apply to Make It So.
provider "azurerm" {
  # if you're using a Service Principal (shared account) 
  #
  # specify via:
  #  - terraform.tfvars
  #  - env variable - e.g. TF_VAR_subscription_id
  #  - or in plain text below for others to steal from your git repo :)
  subscription_id = "${var.ARM_SUBSCRIPTION_ID}"
  tenant_id       = "${var.ARM_TENANT_ID}"
  client_id       = "${var.ARM_CLIENT_ID}"
  client_secret   = "${var.ARM_CLIENT_SECRET}"
}

# an example resource
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_site1}"
  location = "${var.location_site1}"
  tags {
    createdby = "terraform"
  }
  lifecycle {
    prevent_destroy = true
  }  
}
