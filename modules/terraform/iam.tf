resource "google_service_account" "deploy-sa" {
  account_id   = "terraform-deploy"
  description  = "Service account with permissions to deploy resources using terraform"
  display_name = "terraform-deploy"
  project      = var.project.id
}

resource "google_service_account" "state-sa" {
  account_id   = "terraform-state"
  description  = "Service account to sync terraform state"
  display_name = "terraform-state"
  project      = var.project.id
}
