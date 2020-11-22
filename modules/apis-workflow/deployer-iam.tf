resource "google_service_account" "apis_deployer_pubsub_invoker" {
  account_id   = "apis-deployer-invoker"
  description  = "Service account to invoke deployer service from pubsub"
  display_name = "apis-deployer-invoker"
  project      = var.project.id
}
