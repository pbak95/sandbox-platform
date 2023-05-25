terraform {
  source = "git::git@github.com:pbak95/terraform-modules.git//grafana-data-source?ref=main"
}

# Generate provider per specific grafana instance
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite" #overwrite existing file in case provider.tf exists
  contents  = <<-EOF
    provider "grafana" {
      url  = "http://localhost:3000" #TODO change after local DNS is implemented
      auth = "admin:dev" #TODO inject from secret store
      insecure_skip_verify = true
    }
  EOF
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../kube-prometheus-stack"]
}

dependency "loki" {
  config_path = "${get_terragrunt_dir()}/../loki"

  # Configure mock outputs that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
  mock_outputs_merge_strategy_with_state  = "shallow"

  mock_outputs = {
    url  = "https://loki.mock.url"
    auth = {
      username = "mock-user"
      password = "mock-password"
    }
  }
}

locals {
  # Automatically load environment variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  cluster_vars = read_terragrunt_config(find_in_parent_folders("cluster.hcl"))

  # Extract the variables we need for easy access
  cluster_name = local.cluster_vars.locals.cluster_name
}

inputs = {
  type            = "loki"
  name            = "loki-${local.cluster_name}"
  url             = dependency.loki.outputs.url
  tls_skip_verify = true
  credentials     = {
    username = dependency.loki.outputs.auth.username
    password = dependency.loki.outputs.auth.password
  }
  basic_auth_enabled = false
}
