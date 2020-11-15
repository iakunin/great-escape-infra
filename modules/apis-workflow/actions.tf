locals {
  repo = "great-escape-spec-api"
}

data "google_secret_manager_secret_version" "uploader_sa_key" {
  secret = google_secret_manager_secret.bucket_uploader_key_secret.name
}

resource "github_actions_secret" "gcs_uploader_sa_key" {
  repository      = local.repo
  secret_name     = "GCS_UPLOAD_SA_KEY"
  plaintext_value = data.google_secret_manager_secret_version.uploader_sa_key.secret_data
}

# ## Set up deploy workflows
resource "github_repository_file" "ci-workflow" {
  repository          = local.repo
  branch              = "master"
  file                = ".github/workflows/ci.yml"
  commit_message      = format(var.github_user.commit_template, path.module)
  commit_author       = var.github_user.author
  commit_email        = var.github_user.email
  overwrite_on_create = true

  content = templatefile("${path.module}/assets/ci-bazel.tmpl", {
    project_id = var.project.id,
    gcs_bucket = google_storage_bucket.apis.url
  })

  depends_on = [
    github_actions_secret.gcs_uploader_sa_key
  ]
}

