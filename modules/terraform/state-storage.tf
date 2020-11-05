
# module.terraform.google_storage_bucket.state-bucket:
resource "google_storage_bucket" "state-bucket" {
  default_event_based_hold    = false
  force_destroy               = false
  location                    = "EUROPE-NORTH1"
  name                        = "great-escape-infra"
  project                     = "great-escape-294716"
  requester_pays              = false
  storage_class               = "STANDARD"
  uniform_bucket_level_access = false

  versioning {
    enabled = true
  }
}
