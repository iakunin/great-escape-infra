output "admin-ui" {
  value = {
    gcp = {
      url = module.admin-ui.url
    }
    github = {
      repo  = "great-infra"
      owner = "iakunin"
    }
  }
}
