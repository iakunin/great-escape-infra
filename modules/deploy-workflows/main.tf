locals {
  service_name  = trimprefix(var.repository.name, "great-escape-")
  workflow_name = "${local.service_name}-delivery"
  workflow_body = filebase64("${path.module}/assets/cloud-run-service.yaml")
}

resource "google_service_account" "workflow_sa" {
  account_id   = "${local.service_name}-workflow"
  description  = "Service account ${local.service_name} workflow runs as"
  display_name = "${local.service_name}-workflow"
  project      = var.project.id
}

# Allow workflow SA to update cloud run service
resource "google_cloud_run_service_iam_binding" "workflow_sa_binding" {
  location = var.project.region
  project  = var.project.id
  service  = var.service.name
  role     = "roles/run.admin"
  members = [
    "serviceAccount:${google_service_account.workflow_sa.email}",
  ]
}

resource "google_service_account_iam_binding" "workflow_sa_actas_binding" {
  service_account_id = var.service.sa_name
  role               = "roles/iam.serviceAccountUser"
  members = [
    "serviceAccount:${google_service_account.workflow_sa.email}"
  ]
}


module "gcloud" {
  source                = "terraform-google-modules/gcloud/google"
  version               = "~> 2.0"
  platform              = "linux"
  additional_components = ["kubectl", "beta"]

  create_cmd_entrypoint  = "${path.module}/scripts/deploy-workflow.sh"
  create_cmd_body        = "${local.workflow_name} us-central1 ${google_service_account.workflow_sa.email} ${local.workflow_body}"
  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body       = "beta workflows delete ${local.workflow_name} --location us-central1"
}
