resource "google_storage_bucket" "bucket-delete" {
  name = "faas-delete-bucket-${random_integer.ri.result}"
}

resource "google_storage_bucket_object" "archive-delete" {
  name   = "delete.zip"
  bucket = google_storage_bucket.bucket-delete.name
  source = "${var.funcdelete}"
}

resource "google_cloudfunctions_function" "function-delete" {
  name        = "function-delete-${random_integer.ri.result}"
  description = "My function delete"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket-delete.name
  source_archive_object = google_storage_bucket_object.archive-delete.name
  trigger_http          = true
  entry_point           = "helloGET"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker-delete" {
  project        = google_cloudfunctions_function.function-delete.project
  region         = google_cloudfunctions_function.function-delete.region
  cloud_function = google_cloudfunctions_function.function-delete.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
