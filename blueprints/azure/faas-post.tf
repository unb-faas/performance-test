resource "azurerm_resource_group" "rg-faas-post" {
  name     = "rg-faas-post"
  location = "${var.location}"
}
resource "azurerm_storage_account" "sa-faas-post" {
  name                     = "${var.prefix}safaaspost${random_integer.ri.result}"
  resource_group_name      = azurerm_resource_group.rg-faas-post.name
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc-faas-post" {
  name                  = "scfaaspost"
  storage_account_name  = azurerm_storage_account.sa-faas-post.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "blob-faas-post" {
  name                   = "post.zip"
  storage_account_name   = azurerm_storage_account.sa-faas-post.name
  storage_container_name = azurerm_storage_container.sc-faas-post.name
  type                   = "Block"
  source                 = "${var.functionapp}"
}

#In order that the Function App has access to this blob, we need to create a Shared Access Signature:
data "azurerm_storage_account_sas" "sas" {
    connection_string = "${azurerm_storage_account.sa-faas-post.primary_connection_string}"
    https_only = true
    start = "2019-01-01"
    expiry = "2021-12-31"
    resource_types {
        object = true
        container = false
        service = false
    }
    services {
        blob = true
        queue = false
        table = false
        file = false
    }
    permissions {
        read = true
        write = false
        delete = false
        list = false
        add = false
        create = false
        update = false
        process = false
    }
}

resource "azurerm_app_service_plan" "app-serv-plan-faas-post" {
    name = "${var.prefix}-plan-faas-post-${random_integer.ri.result}"
    resource_group_name = azurerm_resource_group.rg-faas-post.name
    location = "${var.location}"
    kind = "FunctionApp"
    sku {
        tier = "Dynamic"
        size = "Y1"
    }
}

resource "azurerm_function_app" "post" {
    name = "${var.prefix}-faas-post-${random_integer.ri.result}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg-faas-post.name}"
    app_service_plan_id = "${azurerm_app_service_plan.app-serv-plan-faas-post.id}"
    storage_connection_string = "${azurerm_storage_account.sa-faas-post.primary_connection_string}"
    version = "~2"

    app_settings = {
        https_only = true
        FUNCTIONS_WORKER_RUNTIME = "node"
        WEBSITE_NODE_DEFAULT_VERSION = "~10"
        FUNCTION_APP_EDIT_MODE = "readonly"
        HASH = "${base64encode(filesha256("${var.functionapp}"))}"
        WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.sa-faas-post.name}.blob.core.windows.net/${azurerm_storage_container.sc-faas-post.name}/${azurerm_storage_blob.blob-faas-post.name}${data.azurerm_storage_account_sas.sas.sas}"
        #   WEBSITE_USE_ZIP
    }
}
