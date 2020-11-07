variable "project" {
  type = object({
    name   = string
    id     = string
    region = string
  })
  default = {
    name   = "great-escape"
    id     = "great-escape-294716"
    region = "europe-north1"
  }
}

variable "github" {
  type = object({
    owner = string,
    managed_repos = list(object({
      name       = string
      build_type = string
    }))
  })
  default = {
    owner = "iakunin",
    managed_repos = [
      {
        name       = "great-escape-api-monolith"
        build_type = "gradle"
      },
      {
        name       = "great-escape-ui-admin"
        build_type = "dockerfile"
      },
      {
        name       = "great-escape-ui-player"
        build_type = "dockerfile"
      }
    ]
  }
}

variable "container-registry-location" {
  description = "See https://cloud.google.com/container-registry/docs/pushing-and-pulling for more info"
  type        = string
  default     = "eu"
}
