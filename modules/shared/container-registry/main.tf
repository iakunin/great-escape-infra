resource "google_container_registry" "main" {
  project  = var.project_id
  location = upper(var.location)
}

data "google_container_registry_image" "admin-ui" {
  name    = "admin-ui"
  project = google_container_registry.main.project
  region  = lower(var.location)
}

data "google_container_registry_image" "backend" {
  name    = "backend"
  project = google_container_registry.main.project
  region  = lower(var.location)
}
