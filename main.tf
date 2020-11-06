terraform {
  backend "gcs" {
    bucket      = "great-escape-infra"
    credentials = "gcp-service-account-state-credentials.json"
    prefix      = "terraform/state"
  }
  required_providers {
    google = {
      version = "~> 3.46.0"
      source = "hashicorp/google"
    }
    random = {
      version = "~> 3.0.0"
      source = "hashicorp/random"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = lower(var.region)
  credentials = "gcp-service-account-deploy-credentials.json"
}

module "terraform" {
  source     = "./modules/terraform"
  project_name = var.project_name
  project_id = var.project_id
  region = var.region
}
