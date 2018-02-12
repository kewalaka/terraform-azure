resource "azurerm_network_interface" "af-jenkins-dev-nic1" {
    name = "af-jenkins-dev-nic1"
    location = "${var.location.name}"
    resource_group_name = "${azurerm_resource_group.agilefabric-rg.name}"
    network_security_group_id = "${azurerm_network_security_group.af-nsg.id}"
    ip_configuration {
        name = "af-jenkins-dev-nic1-configuration"
        subnet_id = "${azurerm_subnet.app_subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.jenkins_dev_public_ip.ip_address}"
        #id = "${azurerm_public_ip.jenkins_dev_public_ip.ip_address}"        
    }
    tags {
    envt = "${var.envt.name}"
    project = "${var.project.name}"
  }
}

#debug
output "af-jenkins-dev-nic1 name" {
    value = "${azurerm_network_interface.af-jenkins-dev-nic1.name}"
}

output "af-jenkins-dev-nic1 subnet_id" {
    value = "${azurerm_network_interface.af-jenkins-dev-nic1.subnet_id}"
}

output "af-jenkins-dev-nic1 subnet_id" {
    value = "${azurerm_network_interface.af-jenkins-dev-nic1.subnet_id}"
}

output "af-jenkins-dev-nic1 virtual_machine_id" {
    value = "${azurerm_network_interface.af-jenkins-dev-nic1.virtual_machine_id}"
}