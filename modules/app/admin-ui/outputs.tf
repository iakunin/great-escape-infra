output "url" {
  value = google_cloud_run_service.admin-ui.status[0].url
}
