locals {
  paths = [
    for repo, props in var.repos_with_endpoints : templatefile(
      "${path.module}/assets/path.tmpl", {
        path   = props.endpoint.gw_route,
        url    = props.endpoint.url
        is_api = props.is_api
      }
    )
  ]
}

resource "google_service_account" "gateway_service_account" {
  account_id   = "api-gateway-sa"
  description  = "Service account API GW signs requests with for backends"
  display_name = "api-gateway-sa"
  project      = var.project.id
}

resource "google_api_gateway_api" "api_gw_api" {
  provider = google-beta
  api_id   = "great-escape"
}

resource "google_api_gateway_api_config" "api_gw_config" {
  provider      = google-beta
  api           = google_api_gateway_api.api_gw_api.api_id
  api_config_id = "great-escape-bootstrap"

  openapi_documents {
    document {
      path = "spec.yaml"
      contents = base64encode(
        templatefile(
          "${path.module}/assets/openapi.tmpl",
          { paths = local.paths }
        )
      )
    }
  }

  gateway_config {
    backend_config {
      google_service_account = google_service_account.gateway_service_account.email
    }
  }
}

# resource "google_api_gateway_gateway" "api_gw" {
#   provider   = google-beta
#   api_config = google_api_gateway_api_config.api_gw_config.id
#   gateway_id = "great-escape"
# }
