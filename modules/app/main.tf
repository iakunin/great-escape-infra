module "admin-ui" {
  source  = "./admin-ui"
  project = var.project

  image = var.admin-ui.image
}

module "backend" {
  source  = "./backend"
  project = var.project
}
