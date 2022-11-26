terraform {
  source = "git::git@github.com:pbak95/terraform-modules.git//loki?ref=main"
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../argocd"]
}

locals {
  # Load environment variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Load cluster variables
  cluster_vars = read_terragrunt_config(find_in_parent_folders("cluster.hcl"))

  namespace     = local.env_vars.locals.namespace
  chart_version = local.env_vars.locals.components.loki.chart_version
}

inputs = {
  namespace          = local.namespace
  chart_version      = local.chart_version
}
