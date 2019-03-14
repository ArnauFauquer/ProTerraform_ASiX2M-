resource "azurerm_resource_group" "main" {
  name     = "resource-group-resources"
  location = "North Europe"
}
resource "azurerm_virtual_machine" "main" {
  name                  = "app-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "MVDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "MV"
    admin_username = "${var.NameUser}"
    admin_password = "${var.PasswordMV}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags {
    environment = "Projecte"
  }
}