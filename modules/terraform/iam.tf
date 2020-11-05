# google_service_account.terraform-deploy:
resource "google_service_account" "deploy-sa" {
  account_id   = "terraform-deploy"
  description  = "Service account with permissions to deploy resources using terraform"
  display_name = "terraform-deploy"
  project      = "great-escape-294716"
}

# google_service_account.terraform-state:
resource "google_service_account" "state-sa" {
  account_id   = "terraform-state"
  description  = "Service account to sync terraform state"
  display_name = "terraform-state"
  project      = "great-escape-294716"
}
