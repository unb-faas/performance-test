resource "azurerm_resource_group" "rg-faas-basic" {
  name     = "rg-faas-basic"
  location = "${var.location}"
}

resource "azurerm_storage_account" "sa-faas-basic" {
  name                     = "${var.prefix}faasbasic${random_integer.ri.result}"
  resource_group_name      = azurerm_resource_group.rg-faas-basic.name
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "app-serv-plan-faas-basic" {
  name                = "${var.prefix}-plan-faas-basic-${random_integer.ri.result}"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.rg-faas-basic.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "basic" {
  name                       = "${var.prefix}-faas-basic-${random_integer.ri.result}"
  location                   = "${var.location}"
  resource_group_name        = azurerm_resource_group.rg-faas-basic.name
  app_service_plan_id        = azurerm_app_service_plan.app-serv-plan-faas-basic.id
  storage_account_name       = azurerm_storage_account.sa-faas-basic.name
  storage_account_access_key = azurerm_storage_account.sa-faas-basic.primary_access_key
  os_type                    = "linux"
}
