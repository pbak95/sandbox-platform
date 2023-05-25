include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/kube-prometheus-stack.hcl"
}

skip = true

inputs = {
  //TODO inject from some secret store
  admin_credentials = {
    user     = "admin"
    password = "dev"
  }
}