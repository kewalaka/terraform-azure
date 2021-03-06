# Azure subscription
variable "ARM_SUBSCRIPTION_ID" {
  description = "The Azure subscription ID"
} 

variable "ARM_TENANT_ID" {
  description = "The Azure tenant ID"
}

# authentication - terraform service principal
variable "ARM_CLIENT_ID" {
  description = "The ID of the service account used by Terraform"
}

variable "ARM_CLIENT_SECRET" {
  description = "The ID of the service account used by Terraform"
}

# resource group & location
variable "resource_group" {
  description = "The name of the resource group to use"
  default     = "kewalaka-appgw"
}

variable "location-site1" {
  description = "The location/region where the resource is created. Changing this forces a new resource to be created."
  default     = "southeastasia"
}

variable "storage_account" {
  type = "map"  
  default = {
    name = "kewalakanz"
    tier = "Standard"   # Valid options are Standard, Premium
    replicationtype = "LRS"   # Valid options are LRS, GRS, RAGRS and ZRS.
  }
}
