variable project {}
variable github {}
variable container_registry {}

variable "github_user" {
  type = map
  default = {
    author          = "terrafrom"
    email           = "terraform@great-escape.ru"
    commit_template = "Managed by Terraform (%s)"
  }
}
