provider "google" {
  credentials = "${file("alpine-charge-262122-91429b2ecb24.json")}"
  project     = "${var.project_id}"
  region      = "${var.regiao}"

}

terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}

resource "google_project_service" "firestore_api" {
  service            = "firestore.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_iam_custom_role" "firestore_access" {
  role_id     = "firestoreAccess"
  title       = "Firestore Access ${var.name_suffix}"
  description = "Includes permissions required for accessing firestore. See https://cloud.google.com/datastore/docs/quickstart#before-you-begin"
  permissions = ["appengine.applications.create", "servicemanagement.services.bind"]
}

resource "google_project_iam_member" "firestore_access_user_groups" {
  for_each = toset(var.user_groups)
  role     = google_project_iam_custom_role.firestore_access.id
  member   = "group:${each.value}"
}

resource "google_project_iam_member" "datastore_owner_user_groups" {
  for_each = toset(var.user_groups)
  role     = "roles/datastore.owner" # see https://cloud.google.com/datastore/docs/quickstart#before-you-begin
  member   = "group:${each.value}"
}

resource "google_datastore_index" "srag2020" {
  kind = "foo"
  properties {
    name = "property_a"
    direction = "ASCENDING"
  }
  properties {
    name = "property_b"
    direction = "ASCENDING"
  }
}

# WORK IN PROGRESS.
# Further development will follow.
# Pending on popular discussion in https://github.com/terraform-providers/terraform-provider-google/issues/3657
