terraform {
  required_version = ">= 0.13"

  backend "gcs" {
    bucket      = "great-escape-infra"
    credentials = "gcp-service-account-state-credentials.json"
    prefix      = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.48.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.2.0"
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
  token = chomp(file("github-token"))
  owner = var.github.owner
}


module "terraform" {
  source  = "./modules/terraform"
  project = var.project
}

# Creating shared resources:
# - container registry
# - dns zone
# - etc.
module "shared" {
  source  = "./modules/shared"
  project = var.project

  depends_on = [
    module.terraform
  ]
}

# Create cloud run services for each corresponding repo
module "cloud-run-service" {
  source           = "./modules/cloud-run-service"
  project          = var.project
  service_defaults = var.service_defaults

  for_each = var.github.repositories
  repository = {
    name  = each.key
    route = each.value.route
  }
}

# Creating deploy GCP workflows for all service created
module "deploy-workflows" {
  source      = "./modules/deploy-workflows"
  project     = var.project
  deployer_sa = module.shared.container_registry.deployer_sa.id

  for_each = var.github.repositories
  repository = {
    name  = each.key
    route = each.value.route
  }
  service = module.cloud-run-service[each.key].service
}

# Setting up github actions CI that includes:
# - service account keys in repo secrets
# - workflow definition that builds docker image and uploads it to GCR
module "ci-github" {
  source  = "./modules/ci-github"
  project = var.project

  container_registry = module.shared.container_registry

  for_each = var.github.repositories
  repository = {
    name  = each.key
    props = each.value
  }
}

#
module "apis-workflow" {
  source  = "./modules/apis-workflow"
  project = var.project
  service = module.cloud-run-service["great-escape-api-spec-deployer"].service
  depends_on = [
    module.terraform
  ]
}

# module "app" {
#   source  = "./modules/app"
#   project = var.project

#   repos_with_endpoints = {
#     for repo, props in var.github.services :
#     repo => merge(props, { endpoint = module.cloud-run-service[repo].endpoint })
#   }
# }



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
