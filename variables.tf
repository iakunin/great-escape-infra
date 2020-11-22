# Probably should be moved to data object
variable project {
  type = object({
    name                        = string
    id                          = string
    region                      = string
    container_registry_location = string
    number                      = number
  })
  default = {
    name                        = "great-escape"
    id                          = "great-escape-294716"
    region                      = "europe-west1"
    container_registry_location = "eu"
    number                      = 472933585094
  }
}

variable github {
  type = object({
    owner = string
    repositories = map(object({
      build_type = string
      route      = string
    }))
  })
  default = {
    owner = "iakunin"
    repositories = {
      "great-escape-api-monolith" = {
        build_type = "gradle-jib"
        route      = "/monolith/"
      },
      "great-escape-ui-admin" = {
        build_type = "dockerfile"
        route      = "/admin/"
      },
      "great-escape-ui-player" = {
        build_type = "dockerfile"
        route      = "/"
      },
      "great-escape-api-spec-deployer" = {
        build_type = "dockerfile"
        route      = "/"
      },
    }
  }
}

variable service_defaults {
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
