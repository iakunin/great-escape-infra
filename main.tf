terraform {
  required_version = ">= 0.13"

  backend "gcs" {
    bucket      = "great-escape-infra"
    credentials = "gcp-service-account-state-credentials.json"
    prefix      = "terraform/state"
  }
  required_providers {
    google = {
      version = "~> 3.46.0"
      source  = "hashicorp/google"
    }
    random = {
      version = "~> 3.0.0"
      source  = "hashicorp/random"
    }
  }
}

provider "google" {
  project     = var.project.id
  region      = lower(var.project.region)
  credentials = "gcp-service-account-deploy-credentials.json"
}

provider "github" {
  token = file("github-token")
  owner = var.github.owner
}


module "terraform" {
  source  = "./modules/terraform"
  project = var.project
}

module "shared" {
  source  = "./modules/shared"
  project = var.project

  location = var.container-registry-location

  depends_on = [
    module.terraform
  ]
}


module "app" {
  source  = "./modules/app"
  project = var.project

  admin-ui = {
    image : "${module.shared.container_registry.url}/admin-ui:latest"
  }
}


module "delivery" {
  source             = "./modules/delivery"
  project            = var.project
  github             = var.github
  container_registry = module.shared.container_registry
}

# @TODO: all required GoogleAPI should be enabled beforehand (test it on new project at google-cloud)
