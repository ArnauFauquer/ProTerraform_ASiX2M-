resource "azurerm_mysql_server" "main" {
  name                         = "mysqlserver"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"

  sku {
    name     = "B_Gen4_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen4"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

administrator_login          = "${var.sqluser}"
administrator_login_password = "${var.sqlpass}"
  version                      = "5.7"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_mysql_database" "main" {
  name                = "wordpress"
  resource_group_name = "${azurerm_resource_group.main.name}"
  server_name         = "${azurerm_mysql_server.main.name}"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}