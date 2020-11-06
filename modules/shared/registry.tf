resource "google_container_registry" "main" {
  project  = var.project.id
  location = var.location
}

data "google_container_registry_repository" "main" {
  project = google_container_registry.main.project
  region  = var.location
}
