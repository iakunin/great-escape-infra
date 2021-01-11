resource "google_storage_bucket" "state-bucket" {
  default_event_based_hold    = false
  force_destroy               = false
  location                    = "europe-north1"
  name                        = "great-escape-infra"
  project                     = var.project.id
  requester_pays              = false
  storage_class               = "STANDARD"
  uniform_bucket_level_access = false

  versioning {
    enabled = true
  }
}
