# Configura o projeto GCP
provider "google" {
  credentials = "${file("alpine-charge-262122-91429b2ecb24.json")}"
  project     = "${var.project_id}"
  region      = "${var.regiao}"

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
  name   = "srag2020-${random_string.random.result}"
  database_version = "MYSQL_5_7"
  region = "${var.regiao}"
  deletion_protection = false

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
  name     = "function"
  instance = google_sql_database_instance.instance.name
  password = "function"
}

resource "google_sql_database" "database" {
  name         = "srag2020"
  instance = google_sql_database_instance.instance.name
  }
