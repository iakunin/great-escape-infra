resource "google_container_registry" "main" {
  project  = var.project_id
  location = upper(var.location)
}

data "google_container_registry_repository" "main" {
  project = google_container_registry.main.project
  region  = lower(var.location)
}
