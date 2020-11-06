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
    # Needed for CloudRUN (https://cloud.google.com/run/docs/reference/iam/roles#gcloud)
    "roles/iam.serviceAccountUser",
  ]
}
