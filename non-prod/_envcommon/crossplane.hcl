terraform {
  source = "git::git@github.com:pbak95/terraform-modules.git//crossplane?ref=main"
}

locals {
  # Load environment variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  namespace     = "crossplane-system-${local.env_vars.locals.environment}"
  environment   = local.env_vars.locals.environment
  chart_version = local.env_vars.locals.components.crossplane.chart_version
}

inputs = {
  namespace     = local.namespace
  environment   = local.environment
  chart_version = local.chart_version
}
