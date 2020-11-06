resource "google_storage_bucket_iam_member" "state-bucket-sa-member" {
  bucket = google_storage_bucket.state-bucket.name
  role   = "roles/storage.objectAdmin"
  member = format("serviceAccount:%s", google_service_account.state-sa.email)
}

variable "deploy-sa-roles" {
  description = "IAM roles to assign to terraform deploy service account"
  type        = list(string)
  default = [
    "roles/storage.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/cloudsql.admin",
    "roles/run.admin",
    # Needed for CloudRUN (https://cloud.google.com/run/docs/reference/iam/roles#gcloud)
    "roles/iam.serviceAccountUser",
  ]
}

resource "google_project_iam_member" "deploy-sa-iam-member" {
  count   = length(var.deploy-sa-roles)
  project = var.project_id
  role    = var.deploy-sa-roles[count.index]
  member  = format("serviceAccount:%s", google_service_account.deploy-sa.email)
}
