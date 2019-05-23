resource "azurerm_mysql_server" "sql" {
  name                  = "databasewordpress"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"

  sku {
    name     = "GP_Gen5_8"
    capacity = 8
    tier     = "GeneralPurpose"
    family   = "Gen5"
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

resource "azurerm_mysql_database" "database_wordpress" {
  name                = "wordpress"
  resource_group_name = "${azurerm_resource_group.main.name}"
  server_name         = "${azurerm_mysql_server.sql.name}"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

}
