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

provider "google-beta" {
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

  depends_on = [
    module.terraform
  ]
}

module "apis-workflow" {
  source  = "./modules/apis-workflow"
  project = var.project
  depends_on = [
    module.terraform
  ]
}

module "ci-github" {
  source  = "./modules/ci-github"
  project = var.project

  container_registry = module.shared.container_registry

  for_each = var.github.managed_repos
  repository = {
    name  = each.key
    props = each.value
  }
}

module "cloud-run-service" {
  source           = "./modules/cloud-run-service"
  project          = var.project
  service_defaults = var.cloud_run_service_defaults

  for_each = var.github.managed_repos
  repository = {
    name  = each.key
    route = each.value.route
  }
}

module "app" {
  source  = "./modules/app"
  project = var.project

  repos_with_endpoints = {
    for repo, props in var.github.managed_repos :
    repo => merge(props, { endpoint = module.cloud-run-service[repo].endpoint })
  }
}



# module "api-gateway" {
#   source = "./modules/api-gateway"

#   for_each = {
#     for repo, props in var.github.managed_repos : repo => props if props.is_api
#   }
#   repository = {
#     name = each.key
#   }
#   # for_each   = var.github.managed_repos ==
#   # repository = each.value.is_api ? {} : null
#   # # for_each = {
#   #   for key, value in var.github.managed_repos if value.is_api
#   # }
#   # repository = {
#   #   name   = each.key
#   #   is_api = each.value.is_api
#   # }
# }

# @TODO: all required GoogleAPI should be enabled beforehand (test it on new project at google-cloud)
