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
    owner         = string,
    managed_repos = list(string)
  })
  default = {
    owner = "iakunin",
    managed_repos = [
      "great-escape"
    ]
  }
}

variable "container-registry-location" {
  description = "See https://cloud.google.com/container-registry/docs/pushing-and-pulling for more info"
  type        = string
  default     = "eu"
}
