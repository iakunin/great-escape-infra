variable "project" {}

variable "admin-ui" {
  type = object({
    image : string
  })
}
