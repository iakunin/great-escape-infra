resource "google_storage_bucket_iam_member" "state-bucket-sa-member" {
  bucket = google_storage_bucket.state-bucket.name
  role   = "roles/storage.objectAdmin"
  member = format("serviceAccount:%s", google_service_account.state-sa.email)
}
