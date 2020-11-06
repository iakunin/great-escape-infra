module "container-registry" {
  source     = "../shared/container-registry"
  location   = var.container-registry-location
  project_id = var.project_id
}

module "admin-ui" {
  source     = "./admin-ui"
  project_id = var.project_id
  region     = var.region
  image      = module.container-registry.image-urls.admin-ui
}

module "backend" {
  source       = "./backend"
  project_id   = var.project_id
  project_name = var.project_name
  region       = var.region
}
