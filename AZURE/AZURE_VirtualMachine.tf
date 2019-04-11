resource "azurerm_resource_group" "main" {
  name     = "Projecte"
  location = "North Europe"
}

resource "azurerm_virtual_machine" "main" {
  name                  = "app-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_B1s"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install apache2 -y"
    ]
  }
  provisioner "file" {
    source     = "docker-compose.yaml"
    destination = "~/docker-compose.yaml"
  }

  connection {
    type     = "ssh"
    user     = "${var.NameUser}"
    password = "${var.PasswordMV}"
  }

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