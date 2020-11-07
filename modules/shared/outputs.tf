output "container_registry" {
  value = {
    url = data.google_container_registry_repository.main.repository_url
    deployer_sa = {
      id     = google_service_account.container_registry_deployer.email
      secret = google_secret_manager_secret.deployer_key_secret.name
    }
  }
}
