variable "project" {}

variable "deploy-sa-roles" {
  description = "IAM roles to assign to terraform deploy service account"
  type        = list(string)
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
    "roles/vpcaccess.admin"
  ]
}
