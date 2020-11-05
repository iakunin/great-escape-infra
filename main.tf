terraform {
  backend "gcs" {
    bucket      = "great-escape-infra"
    credentials = "gcp-service-account-creds.json"
    prefix      = "terraform/state"
  }
}

provider "google" {
  project = "great-escape-294716"
  region  = "europe-north1"
}
