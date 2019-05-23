resource "azurerm_resource_group" "main" {
  name     = "Projecte"
  location = "North Europe"
}

resource "azurerm_virtual_machine" "main" {
  name                  = "app-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_B2s"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  provisioner "file" {
    source     = "docker-compose.yaml"
    destination = "~/docker-compose.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt-get install docker docker-compose -y",
      "sudo docker-compose up -d"
    ]
  }
  connection {
    type     = "ssh"
    user     = "${var.NameUser}"
    password = "${var.PasswordMV}"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "Disc_Sistema"
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
resource "azurerm_managed_disk" "source" {
  name                 = "acctestmd1"
  location             = "North Europe"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = {
    environment = "staging"
  }
}