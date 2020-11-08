resource "google_storage_bucket_iam_member" "state-bucket-sa-member" {
  bucket = google_storage_bucket.state-bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.state-sa.email}"
}

resource "google_project_iam_member" "deploy-sa-terraform-role-iam-member" {
  project = var.project.id
  role    = google_project_iam_custom_role.terraform-role.id
  member  = "serviceAccount:${google_service_account.deploy-sa.email}"
}

data "google_iam_role" "role_permissions" {
  for_each = var.terraform-standard-roles-list
  name     = each.value
}

locals {
  all_permissions = flatten([
    for perms in data.google_iam_role.role_permissions : perms.included_permissions
  ])
}
resource "google_project_iam_custom_role" "terraform-role" {
  role_id     = "terraform"
  title       = "Terraform deployment role"
  description = "Role to grant all permissions to terraform"
  permissions = [
    for p in local.all_permissions : p if ! contains(var.unsupported_perms, p)
  ]
}
