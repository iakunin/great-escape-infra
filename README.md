# great-escape-infra

//TODO
- switch to workflow and allow state modifications only on merged PR

State access and deployment permissions are separated (e.g. when we want allow someone to create terraform manifests and access the state, but don't trust the fucker enough to apply it). That's why 2 separate accounts are used in operations.

## Setting stuff up
- go to GCP console -> IAM -> Service accounts

  - for account `terraform-state@great-escape-294716.iam.gserviceaccount.com` - create new personal key in JSON format
  - save it in root folder as `gcp-service-account-state-credentials.json` (referenced in `main.tf` for `backend`)
  - now you have access to the state stored in GCS bucket

  - for account `terraform-deploy@great-escape-294716.iam.gserviceaccount.com` - create **another** personal key
  - put this key in repo root as `gcp-service-account-deploy-credentials.json` (references in `main.tf` as well, but for `provider`)
  - now you have credentials for deployments

Now **RTFM** (like seriously, all that `terraform show`, `terraform plan` and lalala).

# Credits

Many thanks to my friend [Alexander Pankratov](https://www.linkedin.com/in/alecpankratov/) for his
invaluable contribution to this project. Most likely, without him, I would never have learned 
Terraform.
