resource "google_service_account" "bucket_uploader" {
  account_id   = "apis-bucket-uploader"
  description  = "Service account to upload apis tarballs to storage bucket"
  display_name = "apis-bucket-uploader"
  project      = var.project.id
}

resource "google_service_account_key" "bucket_uploader_key" {
  service_account_id = google_service_account.bucket_uploader.name
}

resource "google_secret_manager_secret" "bucket_uploader_key_secret" {
  secret_id = "apis-bucket-uploader-sa-key"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "bucket_uploader_key_secret_version" {
  secret      = google_secret_manager_secret.bucket_uploader_key_secret.id
  secret_data = base64decode(google_service_account_key.bucket_uploader_key.private_key)
}

