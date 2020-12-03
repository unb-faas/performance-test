provider "azurerm" {  
    
  subscription_id = ""
  tenant_id       = ""
  client_id       = ""
  client_secret   = ""
  
  features {}  
}

resource "random_string" "rg_name" {
 length = 3
 special = false
 upper = false
 lower = false
 number = true
}

resource "azurerm_resource_group" "rg" {
  name     = "unbfaass${random_string.rg_name.result}"
  location = "West Europe"
}

#resource "azurerm_mysql_server" "mysql-unbfaas" {
#  name                = "unbfaas-mysqlserver"
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#
#  administrator_login          = "unbfaas"
#  administrator_login_password = "password"
#
#  sku_name   = "B_Gen5_2"
#  storage_mb = 5120
#  version    = "5.7"
#
#  auto_grow_enabled                 = true
#  backup_retention_days             = 7
#  geo_redundant_backup_enabled      = true
#  infrastructure_encryption_enabled = true
#  public_network_access_enabled     = false
#  ssl_enforcement_enabled           = true
#  ssl_minimal_tls_version_enforced  = "TLS1_2"
#}

#resource "azurerm_mysql_database" "database-unbfaas" {
#  name                = "shifts"
#  resource_group_name = azurerm_resource_group.rg.name
#  server_name         = azurerm_mysql_server.mysql-unbfaas.name
#  charset             = "utf8"
#  collation           = "utf8_unicode_ci"
#}
#
#
