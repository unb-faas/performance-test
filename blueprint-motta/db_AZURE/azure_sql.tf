provider "azurerm" {
subscription_id = ""
tenant_id       = ""
client_id       = ""
client_secret   = ""
features {}
}

resource "azurerm_resource_group" "terraform" {
  name     = "terraformresources"
  location = "West Europe"
}

resource "azurerm_mysql_server" "srag2020" {
  name                = "srag2020"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name

  administrator_login          = "function"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false

}
resource "azurerm_sql_firewall_rule" "rule" {
  name                = "externalaccess"
  resource_group_name = "terraformresources"
  server_name         = azurerm_mysql_server.srag2020.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
