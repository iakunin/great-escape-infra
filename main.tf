terraform {
  backend "gcs" {
    bucket      = "great-escape-infra"
    credentials = "gcp-service-account-state-credentials.json"
    prefix      = "terraform/state"
  }
}
provider "google" {
  project     = "great-escape-294716"
  region      = "europe-north1"
  credentials = "gcp-service-account-deploy-credentials.json"
}

module "terraform" {
  source = "./modules/terraform"
}
