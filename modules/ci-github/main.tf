terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.4.0"
    }
  }
}

locals {
  image_base_name = trimprefix(var.repository.name, "great-escape-")
}

data "google_secret_manager_secret_version" "deployer_sa_key" {
  secret = var.container_registry.deployer_sa.secret
}

resource "github_actions_secret" "gcp_deploy_sa_key" {
  repository      = var.repository.name
  secret_name     = "GCP_DEPLOY_SA_KEY"
  plaintext_value = data.google_secret_manager_secret_version.deployer_sa_key.secret_data
}


## Set up deploy workflows
resource "github_repository_file" "ci-workflow" {
  repository          = var.repository.name
  branch              = "master"
  file                = ".github/workflows/ci.yml"
  commit_message      = format(var.github_user.commit_template, path.module)
  commit_author       = var.github_user.author
  commit_email        = var.github_user.email
  overwrite_on_create = true

  content = templatefile("${path.module}/assets/ci-${var.repository.props.build_type}.tmpl", {
    project_id      = var.project.id,
    image_base_name = local.image_base_name
  })

  depends_on = [
    github_actions_secret.gcp_deploy_sa_key
  ]
}

