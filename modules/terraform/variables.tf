variable "project" {}

variable "terraform-standard-roles-list" {
  description = "IAM roles to assign to terraform deploy service account"
  type        = set(string)
  default = [
    "roles/storage.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/cloudsql.admin",
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/secretmanager.admin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/compute.networkAdmin",
    "roles/dns.admin",
    "roles/vpcaccess.admin",
    "roles/iam.roleAdmin",
    "roles/apigateway.admin",
    "roles/workflows.admin",
    "roles/pubsub.admin",
    "roles/cloudfunctions.admin",
    "roles/source.reader"
  ]
}

variable unsupported_perms {
  description = "Permissions that are not supported by custom roles"
  type        = list(string)
  default = [
    "resourcemanager.projects.list",
    "cloudsql.sslCerts.createEphemeral",
    "run.routes.invoke"
  ]
}
