`workflow` resource is not yet added to terraform google providers (as of end of Nov, 2020):
https://github.com/hashicorp/terraform-provider-google/issues/7258

So storing only workflow templates that are deployed using `gcloud` terraform module.

Also only supported region is `us-central1`, so overriding