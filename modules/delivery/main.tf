module "github" {
  source             = "./github"
  project            = var.project
  github             = var.github
  container_registry = var.container_registry
}
