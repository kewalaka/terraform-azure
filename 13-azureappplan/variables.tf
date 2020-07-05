# resource group & location
variable "resource_group_site1" {
  description = "The name of the resource group to use"
  default     = "appplan"
}

variable "location_site1" {
  description = "The location/region where the resource is created. Changing this forces a new resource to be created."
  default     = "westus2" #"southeastasia" #"australiasoutheast"
}


