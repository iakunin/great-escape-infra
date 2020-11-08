variable project {}
variable container_registry {}
variable repository {}

variable "github_user" {
  type = map
  default = {
    author          = "terrafrom"
    email           = "terraform@great-escape.ru"
    commit_template = "Managed by Terraform (%s)"
  }
}
