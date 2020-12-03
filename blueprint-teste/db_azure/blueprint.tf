provider "azurerm" {
  version = "=2.4.0"

  subscription_id = "04d9a36b-f077-4930-b151-03b5d60e01b7"
  client_id       = "2d7292c0-da07-43be-b84d-12f93f9b20c5"
  client_secret   = "71ff1b17-6df2-4c3d-ba26-4d6667a70ca0"
  tenant_id       = "ec359ba1-630b-4d2b-b833-c8e6d48f8059"

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

resource "azurerm_mysql_server" "mysql-unbfaas" {
  name                = "unbfaas-mysqlserver"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = "unbfaas"
  administrator_login_password = "password"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "database-unbfaas" {
  name                = "shifts"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_server.mysql-unbfaas.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

