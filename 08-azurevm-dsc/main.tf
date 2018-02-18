provider "azurerm" {
  # if you're using a Service Principal (shared account) then either set the environment
  # variables, or fill these in:  # subscription_id = "..."  # client_id       = "..."  
  # client_secret   = "..."  # tenant_id       = "..."
  subscription_id = "${var.ARM_SUBSCRIPTION_ID}"
  tenant_id       = "${var.ARM_TENANT_ID}"
  client_id       = "${var.ARM_CLIENT_ID}"
  client_secret   = "${var.ARM_CLIENT_SECRET}"
}

data "azurerm_resource_group" "rg" {
  name = "${var.resource_group}"
}

# Networking
resource "azurerm_virtual_network" "operationalvnet" {
  name                = "${data.azurerm_resource_group.rg.name}operationalvnet"
  location            = "${data.azurerm_resource_group.rg.location}"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "datasubnet" {
  name                 = "datasubnet"
  virtual_network_name = "${azurerm_virtual_network.operationalvnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
  address_prefix       = "10.0.3.0/24"
}

# Automation
resource "azurerm_automation_account" "automation" {
  name                = "kewalaka"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  sku {
    name = "Basic"
  }

  tags {
    environment = "${var.tags["environment"]}"
    project     = "${var.tags["project"]}"
    created_by  = "terraform"    
  }
}

resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  storage_account_name  = "${var.storage_account}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "DscMetaConfigs" {
  name = "DscMetaConfigs.ps1"
  source = "${path.module}\\scripts\\DscMetaConfigs.ps1"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  storage_account_name  = "${var.storage_account}"
  storage_container_name = "${azurerm_storage_container.scripts.name}"
  type = "Block"
}

resource "azurerm_storage_blob" "Execute_DscScripts" {
  name = "Execute_DscScripts.ps1"
  source = "${path.module}\\scripts\\Execute_DscScripts.ps1"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  storage_account_name  = "${var.storage_account}"
  storage_container_name = "${azurerm_storage_container.scripts.name}"
  type = "Block"    
}



# The virtual machine
resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.vm_name}-ipconfig"
    subnet_id = "${azurerm_subnet.datasubnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "virtual_machine" {
  name                = "${var.vm_name}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_DS1_v2"
  license_type          = "Windows_Server"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    os_type           = "windows"
    disk_size_gb      = "256"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${var.vm_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
    }
  }

  tags {
    role       = "test_server"
    created_by = "terraform"
  }
}

# based on https://medium.com/modern-stack/bootstrap-a-vm-to-azure-automation-dsc-using-terraform-f2ba41d25cd2
resource "azurerm_virtual_machine_extension" "dsc" {
  name                 = "DevOpsDSC"
  location = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  virtual_machine_name = "${var.vm_name}"
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.74"
  depends_on           = ["azurerm_virtual_machine.virtual_machine"]

  settings = <<SETTINGS
        {
            "WmfVersion": "latest",
            "ModulesUrl": "https://eus2oaasibizamarketprod1.blob.core.windows.net/automationdscpreview/RegistrationMetaConfigV2.zip",
            "ConfigurationFunction": "RegistrationMetaConfigV2.ps1\\RegistrationMetaConfigV2",
            "Privacy": {
                "DataCollection": ""
            },
            "Properties": {
                "RegistrationKey": {
                  "UserName": "PLACEHOLDER_DONOTUSE",
                  "Password": "PrivateSettingsRef:registrationKeyPrivate"
                },
                "RegistrationUrl": "${var.dsc_endpoint}",
                "NodeConfigurationName": "${var.dsc_config}",
                "ConfigurationMode": "${var.dsc_mode}",
                "ConfigurationModeFrequencyMins": 15,
                "RefreshFrequencyMins": 30,
                "RebootNodeIfNeeded": false,
                "ActionAfterReboot": "continueConfiguration",
                "AllowModuleOverwrite": false
            }
        }
    SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Items": {
        "registrationKeyPrivate" : "${var.dsc_key}"
      }
    }
PROTECTED_SETTINGS
}