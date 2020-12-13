###https://firebase.google.com/docs/firestore/solutions/automate-database-create
provider "google" {
  credentials = "${file("alpine-charge-262122-91429b2ecb24.json")}"
  project     = "${var.project_id}"
  region      = "${var.regiao}"

}
#funciona
# resource "google_datastore_index" "default" {
#   kind = "foo"
#   properties {
#     name = "property_a"
#     direction = "ASCENDING"
#   }
#   properties {
#     name = "property_b"
#     direction = "ASCENDING"
#   }
# }

resource "google_bigtable_instance" "srag2020" {
  name = "srag2020"
  deletion_protection=false

  cluster {
    cluster_id   = "tf-srag2020-cluster"
    zone         = "us-central1-b"
    num_nodes    = 1
    storage_type = "HDD"
  }

  lifecycle {
    prevent_destroy = false
  }

  labels = {
    my-label = "dev-label"
  }
}
resource "google_bigtable_table" "csv_table" {
  name          = "csv-table"
  instance_name = google_bigtable_instance.srag2020.name
  #split_keys    = ["a", "b", "c"]

  lifecycle {
    prevent_destroy = false
  }
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/bigtable.user"
    members = [
      "user:marcelosanak@gmail.com",
    ]
  }
}
resource "google_bigtable_instance_iam_policy" "editor" {
  project     = "${var.project_id}"
  instance    = google_bigtable_instance.srag2020.name
  policy_data = data.google_iam_policy.admin.policy_data
}
# resource "google_project_iam_custom_role" "rolefirestone" {
#   role_id     = "rolefirestone2"
#   title       = "My Custom Role"
#   description = "A description"
#   permissions = ["resourcemanager.projectCreator"]
# }

# resource "google_project" "terraform" {
#   name = "terraform"
#   project_id = "${var.project_id}"
#   org_id = "917776558815"
# }

# resource "google_app_engine_application" "app" {
# #  project     = google_project.terraform.project_id
#   project     = "${var.project_id}"
#   location_id = "${var.regiao}"
#   database_type = "CLOUD_FIRESTORE"
# }
# resource "google_project_service" "firestore" {
#   service = "firestore.googleapis.com"
#   disable_dependent_services = true
# }
#
# resource google_project_iam_member "firestore_user" {
#   role   = "roles/datastore.user"
#   member = "serviceAccount:terraform-motta@alpine-charge-262122.iam.gserviceaccount.com"
# }
