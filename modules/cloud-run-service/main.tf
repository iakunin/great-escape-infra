locals {
  service_name = trimprefix(var.repository.name, "great-escape-")
}

resource "google_service_account" "service_account" {
  account_id   = "${local.service_name}-sa"
  description  = "Service account ${local.service_name} runs as"
  display_name = "${local.service_name}-sa"
  project      = var.project.id
}

resource "google_cloud_run_service" "service" {
  name     = local.service_name
  location = var.project.region

  template {
    spec {
      service_account_name = google_service_account.service_account.email
      containers {
        image = "gcr.io/cloudrun/placeholder"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template,
      traffic,
      metadata
    ]
  }
}
