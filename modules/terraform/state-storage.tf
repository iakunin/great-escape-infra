
# module.terraform.google_storage_bucket.state-bucket:
resource "google_storage_bucket" "state-bucket" {
  default_event_based_hold    = false
  force_destroy               = false
  location                    = "EUROPE-NORTH1"
  name                        = "great-escape-infra"
  project                     = var.project_id
  requester_pays              = false
  storage_class               = "STANDARD"
  uniform_bucket_level_access = false

  versioning {
    enabled = true
  }
}
