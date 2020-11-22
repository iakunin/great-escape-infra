resource "google_storage_bucket" "apis" {
  name                        = "great-escape-apis"
  project                     = var.project.id
  location                    = var.project.region
  default_event_based_hold    = false
  force_destroy               = false
  requester_pays              = false
  storage_class               = "STANDARD"
  uniform_bucket_level_access = false
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "bucket_uploader" {
  bucket = google_storage_bucket.apis.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.bucket_uploader.email}"
}

resource "google_pubsub_topic" "bucket_topic" {
  name = "apis-storage-notifications"
}

data "google_storage_project_service_account" "gcs_account" {
}

resource "google_pubsub_topic_iam_binding" "bucket_topic_binding" {
  topic = google_pubsub_topic.bucket_topic.id
  role  = "roles/pubsub.publisher"
  members = [
    "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
  ]
}

resource "google_storage_notification" "notification" {
  bucket         = google_storage_bucket.apis.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.bucket_topic.id
  event_types = [
    "OBJECT_FINALIZE",
    "OBJECT_METADATA_UPDATE"
  ]
  depends_on = [
    google_pubsub_topic_iam_binding.bucket_topic_binding
  ]
}



