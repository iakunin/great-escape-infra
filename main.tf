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

module "terraform" {
  source  = "./modules/terraform"
  project = var.project
}

module "shared" {
  source  = "./modules/shared"
  project = var.project

  location = var.container-registry-location
}

module "app" {
  source  = "./modules/app"
  project = var.project

  admin-ui = {
    image : "${module.shared.container-registry-url}/admin-ui:latest"
  }
}

# @TODO: all required GoogleAPI should be enabled beforehand (test it on new project at google-cloud)
