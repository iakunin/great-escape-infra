resource "google_cloud_run_service" "admin-ui" {
  name     = var.service_name
  location = var.project.region
  project  = var.project.id

  template {
    spec {
      containers {
        image = var.image
        ports {
          container_port = 80
        }
      }
    }
  }
}

# @TODO: refactor this access-policy via explicit IAM-entities list (who has an access to this cloud-run)
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.admin-ui.location
  project     = google_cloud_run_service.admin-ui.project
  service     = google_cloud_run_service.admin-ui.name
  policy_data = data.google_iam_policy.noauth.policy_data
}
