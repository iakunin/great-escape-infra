output service_account {
  value = google_service_account.service_account.email
}

output endpoint {
  value = {
    url      = google_cloud_run_service.service.status[0].url
    gw_route = var.repository.route
  }
}
