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

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "motta-cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
  offer_type          = "Standard"
  #kind                = "GlobalDocumentDB"
  kind                = "MongoDB"
  enable_automatic_failover = false

  # capabilities {
  #   name = "EnableAggregationPipeline"
  # }
  #
  # capabilities {
  #   name = "mongoEnableDocLevelTTL"
  # }

  capabilities {
    #name = "MongoDBv3.4"
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  # geo_location {
  #   location          = azurerm_resource_group.terraform.location
  #   failover_priority = 1
  # }

  geo_location {
    location          = "North Europe"
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "example" {
  name                = "motta-cosmos-mongo-db"
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  account_name        = azurerm_cosmosdb_account.db.name
  throughput          = 400
}

resource "azurerm_cosmosdb_table" "example" {
  name                = "motta-cosmos-table"
  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name
  account_name        = data.azurerm_cosmosdb_account.example.name
  throughput          = 400
}
