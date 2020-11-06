variable "project_name" {
  type    = string
  default = "great-escape"
}

variable "project_id" {
  type    = string
  default = "great-escape-294716"
}

variable "region" {
  type    = string
  default = "europe-north1"
}

variable "container-registry-location" {
  description = "See https://cloud.google.com/container-registry/docs/pushing-and-pulling for more info"
  type        = string
  default     = "eu"
}
