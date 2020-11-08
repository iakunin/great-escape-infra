variable project {
  type = object({
    name                        = string
    id                          = string
    region                      = string
    container_registry_location = string
  })
  default = {
    name                        = "great-escape"
    id                          = "great-escape-294716"
    region                      = "europe-west1"
    container_registry_location = "eu"
  }
}

variable github {
  type = object({
    owner = string
    managed_repos = map(object({
      build_type = string
      is_api     = bool
      route      = string
    }))
  })
  default = {
    owner = "iakunin"
    managed_repos = {
      "great-escape-api-monolith" = {
        build_type = "gradle-jib"
        is_api     = true
        route      = "/monolith/"
      },
      "great-escape-ui-admin" = {
        build_type = "dockerfile"
        is_api     = false
        route      = "/admin/"
      },
      "great-escape-ui-player" = {
        build_type = "dockerfile"
        is_api     = false
        route      = "/"
      }
    }
  }
}

variable cloud_run_service_defaults {
  type = object({
    healthcheck = object({
      port = number
      url  = string
    })
  })
  default = {
    healthcheck = {
      port = 80
      url  = "/health"
    }
  }
}
