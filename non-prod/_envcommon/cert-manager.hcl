terraform {
  source = "git::git@github.com:pbak95/terraform-modules.git//cert-manager?ref=main"
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../platform-namespace"]
}

locals {
  # Load environment variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  namespace     = local.env_vars.locals.namespace
  environment   = local.env_vars.locals.environment
  chart_version = local.env_vars.locals.components.cert-manager.chart_version
}

inputs = {
  namespace     = local.namespace
  environment   = local.environment
  chart_version = local.chart_version
}
