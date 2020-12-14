
resource "azurerm_storage_account" "sa-faas-post" {
  name                     = "faaspost${random_integer.ri.result}"
  resource_group_name      = azurerm_resource_group.rg-faas-evaluation.name
  location                 = var.location
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
  source                 = var.functionpost
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

# resource "azurerm_app_service_plan" "app-serv-plan-faas-post" {
#     name = "${var.prefix}-plan-faas-post-${random_integer.ri.result}"
#     resource_group_name = azurerm_resource_group.rg-faas-evaluation.name
#     location = var.location
#     kind = "FunctionApp"
#     sku {
#         tier = "Dynamic"
#         size = "Y1"
#     }
# }

resource "azurerm_function_app" "post" {
    name = "${var.prefix}-faas-post-${random_integer.ri.result}"
    location = var.location
    resource_group_name = azurerm_resource_group.rg-faas-evaluation.name
    app_service_plan_id = azurerm_app_service_plan.app-serv-plan-faas-basic.id
    storage_account_name = azurerm_storage_account.sa-faas-post.name
    storage_account_access_key = azurerm_storage_account.sa-faas-post.primary_access_key

    # storage_connection_string = "${azurerm_storage_account.sa-faas-post.primary_connection_string}"
    version = "~2"

    app_settings = {
        https_only = true
        FUNCTIONS_WORKER_RUNTIME = "node"
        WEBSITE_NODE_DEFAULT_VERSION = "~10"
        FUNCTION_APP_EDIT_MODE = "readonly"
        HASH = "${base64encode(filesha256("${var.functionpost}"))}"
        WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.sa-faas-post.name}.blob.core.windows.net/${azurerm_storage_container.sc-faas-post.name}/${azurerm_storage_blob.blob-faas-post.name}${data.azurerm_storage_account_sas.sas.sas}"
        #   WEBSITE_USE_ZIP
   
        WEBSITE_USE_ZIP = "https://${azurerm_storage_account.sa-faas-post.name}.blob.core.windows.net/${azurerm_storage_container.sc-faas-post.name}/${azurerm_storage_blob.blob-faas-post.name}${data.azurerm_storage_account_sas.sas.sas}"
        #WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/${azurerm_storage_container.storage_container.name}/${azurerm_storage_blob.storage_blob.name}${data.azurerm_storage_account_sas.storage_sas.sas}"
    
   
    }
}

resource "azurerm_template_deployment" "function_keys" {
  name = "node2fass${random_integer.ri.result}"
  parameters = {
    "functionApp" = "${azurerm_function_app.post.name}"
  }
  resource_group_name    = "${azurerm_resource_group.rg-faas-evaluation.name}"
  deployment_mode = "Incremental"

  template_body = <<BODY
  {
      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
          "functionApp": {"type": "string", "defaultValue": ""}
      },
      "variables": {
          "functionAppId": "[resourceId('Microsoft.Web/sites', parameters('functionApp'))]"
      },
      "resources": [
      ],
      "outputs": {
          "functionkey": {
              "type": "string",
              "value": "[listkeys(concat(variables('functionAppId'), '/host/default'), '2018-11-01').functionKeys.default]"                                                                                }
      }
  }
  BODY
}

output "function_url" {
  value = "https://${azurerm_function_app.post.default_hostname}/api/post?code=${lookup(azurerm_template_deployment.function_keys.outputs, "functionkey")}"
}

output "azure_function_url" {
    description = "The resource ids of the app services created."
    value       = azurerm_function_app.post.*.default_hostname
}