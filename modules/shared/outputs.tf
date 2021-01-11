output "container_registry" {
  value = {
    url = data.google_container_registry_repository.main.repository_url
    deployer_sa = {
      id     = google_service_account.container_registry_deployer.email
      secret = google_secret_manager_secret.deployer_key_secret.name
    }
  }
}

output "serverless_vpc_connector" {
  value = google_vpc_access_connector.serverless_vpc_connector.id
}

output "internal_dns_zone" {
  value = google_dns_managed_zone.internal_dns_zone.id
}
