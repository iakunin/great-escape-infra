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

variable "container-registry-location" {
  description = "See https://cloud.google.com/container-registry/docs/pushing-and-pulling for more info"
  type        = string
  default     = "eu"
}
