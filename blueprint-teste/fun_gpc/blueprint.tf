provider "google" {
credentials = file("./credentials.json")
project     = "favorable"
region      = "us-central1"
}

resource "google_storage_bucket" "bucket" {
  name = "test-bucket-thamires"
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./index.zip"
}


resource "google_cloudfunctions_function" "function" {
  name        = "addReg"
  description = "My function"
  runtime     = "nodejs12"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  ingress_settings      = "ALLOW_ALL"
  timeout               = 60
  entry_point           = "addReg"
  environment_variables = {
    DB_HOST = "34.69.53.201:3306",
    DB_USER = "catraca",
    DB_PASS = "catraca",
    DB_NAME = "shifts"
  }
}


  resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}






