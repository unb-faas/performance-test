resource "azurerm_resource_group" "rg-faas-evaluation" {
  name     = "faas-evaluation"
  location = var.location
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "ac-cosmos-dbaas" {
  name                = "${var.prefix}-ac-dbaas-${random_integer.ri.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-faas-evaluation.name
  offer_type          = "Standard"
  kind                = "MongoDB"
  enable_automatic_failover = false

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "db-covid19" {
  name                = var.table_name
  resource_group_name = azurerm_resource_group.rg-faas-evaluation.name
  account_name        = azurerm_cosmosdb_account.ac-cosmos-dbaas.name
  throughput          = 400
}
resource "azurerm_cosmosdb_mongo_collection" "covid19" {
  name                = var.table_name
  resource_group_name = azurerm_resource_group.rg-faas-evaluation.name
  account_name        = azurerm_cosmosdb_account.ac-cosmos-dbaas.name
  database_name       = azurerm_cosmosdb_mongo_database.db-covid19.name

  default_ttl_seconds = "-1" # no expiration
   shard_key           = "namespace"
   throughput          = 400
    index {
         keys   = [
            "_id",
         ]
         unique = true
     }
}
