resource "google_storage_bucket" "bucket-basic" {
  name = "faas-basic-bucket-${random_integer.ri.result}"
}

resource "google_storage_bucket_object" "archive-basic" {
  name   = "basic.zip"
  bucket = google_storage_bucket.bucket-basic.name
  source = "${var.funcbasic}"
}

resource "google_cloudfunctions_function" "function-basic" {
  name        = "function-basic-${random_integer.ri.result}"
  description = "My function basic"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket-basic.name
  source_archive_object = google_storage_bucket_object.archive-basic.name
  trigger_http          = true
  entry_point           = "helloGET"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker-basic" {
  project        = google_cloudfunctions_function.function-basic.project
  region         = google_cloudfunctions_function.function-basic.region
  cloud_function = google_cloudfunctions_function.function-basic.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
