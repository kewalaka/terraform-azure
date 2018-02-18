# Azure subscription
variable "ARM_SUBSCRIPTION_ID" { description = "The Azure subscription ID"  } 
variable "ARM_TENANT_ID"       { description = "The Azure tenant ID" }

# authentication - terraform service principal
variable "ARM_CLIENT_ID"     { description = "The ID of the service account used by Terraform" }
variable "ARM_CLIENT_SECRET" { description = "The ID of the service account used by Terraform" }

# resource group & location
variable "resource_group" {
  description = "The name of the resource group to use"
  default     = "kewalaka"
}

variable "location-site1" {
  description = "The location/region where the resource is created. Changing this forces a new resource to be created."
  default     = "australiasoutheast"
}

variable "tags" {
  type = "map"

  default = {
    environment = "lab"
    project     = "terraformdemo"
  }
}

variable "storage_account" {
    description = "Storage account to use for the scripts"
    default = "kewalakanz"
}

variable "vm_name" {
  description = "What is the name of the server you want to create"
  default = "ashcazd-hms-002"
}
variable "admin_username" {
  default = "devops"
}
variable "admin_password" {
}

variable "dsc_key" {
}

variable "dsc_endpoint" {
}

variable "storageAccountName" {
}

variable "storageAccountKey" {
}

variable dsc_config {
  default = "node_configuration_you_want_applied__can_leave_blank"
}
variable dsc_mode {
  default = "applyAndMonitor"
}

