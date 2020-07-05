# use terraform init to put down this provider
#     terraform plan to show what it will do
#     terraform apply to Make It So.
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "appplan" {
  name     = var.resource_group_site1
  location = var.location_site1
  tags = {
    createdby = "terraform"
  }
}

resource "azurerm_app_service_plan" "appplan" {
  name                         = "appplan"
  resource_group_name          = azurerm_resource_group.appplan.name
  location                     = var.location_site1
  is_xenon                     = false
  kind                         = "App" # aka Windows
  maximum_elastic_worker_count = 1
  per_site_scaling             = false
  reserved                     = false
  sku {
    capacity = 1
    size     = "S1"
    tier     = "Standard"
  }
}

resource "azurerm_app_service" "stum" {
  name                = "stum"
  resource_group_name = azurerm_resource_group.appplan.name
  location            = var.location_site1
  app_service_plan_id = azurerm_app_service_plan.appplan.id
  client_cert_enabled = false
  enabled             = true
  https_only          = true
  auth_settings {
    enabled = false
  }
  site_config {
    always_on = true
    default_documents = [
      "index.htm",
      "index.html"
    ]
    ftps_state                = "Disabled"
    health_check_path         = ""
    http2_enabled             = true
    local_mysql_enabled       = false
    managed_pipeline_mode     = "Integrated"
    min_tls_version           = "1.2"
    remote_debugging_enabled  = false
    scm_type                  = "GitHub"
    use_32_bit_worker_process = true
    websockets_enabled        = false
  }
}
