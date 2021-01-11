# Allow pubsub service account to generate aith tokens
resource "google_project_iam_binding" "pubsub_tokens_binding" {
  project = var.project.id
  role    = "roles/iam.serviceAccountTokenCreator"
  members = [
    "serviceAccount:service-${var.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com",
  ]
}

# Allow invoker SA to invoke deployer cloud run
resource "google_cloud_run_service_iam_binding" "pubsub_binding" {
  location = var.project.region
  project  = var.project.id
  service  = var.service.name
  role     = "roles/run.invoker"
  members = [
    "serviceAccount:${google_service_account.apis_deployer_pubsub_invoker.email}",
  ]
}

# Creating pubsub subscription that will push messages to deployer service
resource "google_pubsub_subscription" "apis_bucket_subscription" {
  name  = "apis-bucket-deployer-subscription"
  topic = google_pubsub_topic.bucket_topic.name
  push_config {
    push_endpoint = var.service.url
    oidc_token {
      service_account_email = google_service_account.apis_deployer_pubsub_invoker.email
    }
  }
}
