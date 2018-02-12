resource "azurerm_virtual_machine" "af-jenkins-dev" {
    name = "af-jenkins-dev"
    location = "${var.location.name}"
    resource_group_name = "${azurerm_resource_group.agilefabric-rg.name}"    
    network_interface_ids = ["${azurerm_network_interface.af-jenkins-dev-nic1.id}"]
    vm_size = "Standard_DS2"
    storage_image_reference {
      publisher = "${var.centos7_image.publisher}"
      offer = "${var.centos7_image.offer}"
      sku = "${var.centos7_image.sku}"
      version = "${var.centos7_image.version}"
    }

    storage_os_disk {
        name = "jenkins-dev-osdisk"
        vhd_uri = "${azurerm_storage_account.agilefabric.primary_blob_endpoint}${azurerm_storage_container.agilefabric.name}/agilefabric-jenkins-dev.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    storage_data_disk {
        name = "jenkins-dev-datadisk"
        vhd_uri = "${azurerm_storage_account.agilefabric.primary_blob_endpoint}${azurerm_storage_container.agilefabric.name}/agilefabric-jenkins-data.vhd"
        disk_size_gb = "30"        
        create_option = "attach"
        lun = 1
    }

    os_profile {
    computer_name = "af-jenkins-dev"
    admin_username = "testadmin"
    admin_password = "Password1234!"
    #custom_data 
    }

    os_profile_linux_config {
     disable_password_authentication = true
     ssh_keys {
        path = "/tmp"
        key_data = "${file("./agilefabric_dev_rsa.pub")}"
      }
    }
}

#debug
output "af-jenkins-dev name" {
    value = "${azurerm_virtual_machine.af-jenkins-dev.name}"
}

output "af-jenkins-dev id" {
    value = "${azurerm_virtual_machine.af-jenkins-dev.id}"
}