resource "google_container_registry" "main" {
  project  = var.project.id
  location = var.project.container_registry_location
}

resource "google_service_account" "container_registry_deployer" {
  account_id   = "gcr-deployer"
  description  = "Service account to deploy images to container registry"
  display_name = "gcr-deployer"
  project      = var.project.id
}

resource "google_storage_bucket_iam_member" "deployer" {
  bucket = google_container_registry.main.id
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.container_registry_deployer.email}"
}
resource "google_service_account_key" "deployer_key" {
  service_account_id = google_service_account.container_registry_deployer.name
}
# put to secrets manager
resource "google_secret_manager_secret" "deployer_key_secret" {
  secret_id = "container-registry-deployer-sa-key"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "deployer_key_secret_version" {
  secret      = google_secret_manager_secret.deployer_key_secret.id
  secret_data = base64decode(google_service_account_key.deployer_key.private_key)
}

data "google_container_registry_repository" "main" {
  project = google_container_registry.main.project
  region  = var.project.container_registry_location
}

