provider "google" {
credentials = file("./credention-db.json")
project     = "favorable"
region      = "us-central1"
}

resource "random_string" "random" {
  length = 4
  special = false
  upper = false
}


locals {
  onprem = ["0.0.0.0/0"]
}

resource "google_sql_database_instance" "instance" {
  name   = "dbcatraca2-${random_string.random.result}"
  database_version = "MYSQL_5_7"
  region = "us-central1"

  settings {

    tier = "db-f1-micro"
    
    ip_configuration {

      dynamic "authorized_networks" {
        for_each = local.onprem
        iterator = onprem

        content {
          name  = "onprem-${onprem.key}"
          value = onprem.value
        }
      }
    }
  }

}

resource "google_sql_user" "users" {
  name     = "catraca"
  instance = google_sql_database_instance.instance.name 
  password = "catraca"
}

resource "google_sql_database" "database" {
  name         = "shifts"
  instance = google_sql_database_instance.instance.name 
  }









