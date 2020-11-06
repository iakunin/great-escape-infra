resource "google_storage_bucket_iam_member" "state-bucket-sa-member" {
  bucket = google_storage_bucket.state-bucket.name
  role   = "roles/storage.objectAdmin"
  member = format("serviceAccount:%s", google_service_account.state-sa.email)
}

resource "google_project_iam_member" "deploy-sa-iam-member" {
  count   = length(var.deploy-sa-roles)
  project = var.project.id
  role    = var.deploy-sa-roles[count.index]
  member  = format("serviceAccount:%s", google_service_account.deploy-sa.email)
}
