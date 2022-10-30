# TODO change source value from path into git repo URL(local.base_source_url) and reference(local.ref)
terraform {
  source = "git::git@github.com:pbak95/terraform-modules.git//kubernetes-namespace?ref=main"
}

locals {
  # Load environment variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Extract the variables we need for easy access
  namespace = local.environment_vars.locals.namespace
}

inputs = {
  namespace = local.namespace
}
