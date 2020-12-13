resource "google_storage_bucket" "bucket-post" {
  name = "faas-post-bucket-${random_integer.ri.result}"
}

resource "google_storage_bucket_object" "archive-post" {
  name   = "post.zip"
  bucket = google_storage_bucket.bucket-post.name
  source = "${var.funcpost}"
}

resource "google_cloudfunctions_function" "function-post" {
  name        = "function-post-${random_integer.ri.result}"
  description = "My function post"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket-post.name
  source_archive_object = google_storage_bucket_object.archive-post.name
  trigger_http          = true
  entry_point           = "helloGET"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker-post" {
  project        = google_cloudfunctions_function.function-post.project
  region         = google_cloudfunctions_function.function-post.region
  cloud_function = google_cloudfunctions_function.function-post.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
