variable "project" {
  type = object({
    name   = string
    id     = string
    region = string
  })
}

variable "instance" {
  type = object({
    name = string
  })
}

variable "database" {
  type = object({
    name = string
    user = string
  })
}
