terraform {
  source = "git::git@github.com:pbak95/terraform-modules.git//ingress-nginx?ref=main"
}

locals {
  # Load environment variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  namespace     = local.env_vars.locals.namespace
  chart_version = local.env_vars.locals.components.ingress-nginx.chart_version
}

inputs = {
  monitoring_namespace = local.namespace
  chart_version        = local.chart_version
}
