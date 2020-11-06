variable "project_name" {}
variable "project_id" {}
variable "region" {}
variable "admin-ui" {
  type = object({
    image : string
  })
}
