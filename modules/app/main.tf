module "admin-ui" {
  source     = "./admin-ui"
  project_id = var.project_id
  region     = var.region
  image      = var.admin-ui.image
}

module "backend" {
  source       = "./backend"
  project_id   = var.project_id
  project_name = var.project_name
  region       = var.region
}
