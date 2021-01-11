resource "google_vpc_access_connector" "serverless_vpc_connector" {
  name          = "serverless-vpc-connector"
  region        = var.project.region
  network       = "default"
  ip_cidr_range = "10.64.0.0/28"
}

resource "google_dns_managed_zone" "internal_dns_zone" {
  name       = "great-escape-internal"
  dns_name   = "great-escape.internal."
  visibility = "private"
  private_visibility_config {
    networks {
      network_url = "projects/great-escape-294716/global/networks/default"
    }
  }
}

