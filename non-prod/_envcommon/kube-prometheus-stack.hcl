terraform {
  source = "git::git@github.com:pbak95/terraform-modules.git//kube-prometheus-stack?ref=main"
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../platform-namespace"]
}

locals {
  # Load environment variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Load cluster variables
  cluster_vars = read_terragrunt_config(find_in_parent_folders("cluster.hcl"))

  namespace     = local.env_vars.locals.namespace
  chart_version = local.env_vars.locals.components.kube-prometheus-stack.chart_version

  cluster_name = local.cluster_vars.locals.cluster_name
}

inputs = {
  namespace          = local.namespace
  chart_version      = local.chart_version
  destination_server = "https://kubernetes.default.svc"
  cluster            = local.cluster_name
}
