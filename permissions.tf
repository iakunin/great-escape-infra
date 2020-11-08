resource "google_cloud_run_service_iam_member" "member" {
  for_each = module.cloud-run-service

  location = var.project.region
  project  = var.project.id
  service  = trimprefix(each.key, "great-escape-")
  role     = "roles/run.invoker"
  member   = "serviceAccount:${module.app.api_gw_service_account}"
}
