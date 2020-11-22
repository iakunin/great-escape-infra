output "service" {
  value = {
    name     = google_cloud_run_service.service.name
    url      = google_cloud_run_service.service.status[0].url
    sa_email = google_service_account.service_account.email
    sa_name  = google_service_account.service_account.name
  }
}
