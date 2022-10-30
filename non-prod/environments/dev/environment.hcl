locals {
  environment = "dev"
  namespace   = "platform-${local.environment}"
  components = {
    ingress-nginx = {
      chart_version = "9.3.18"
    }
    cert-manager = {
      chart_version = "0.4.17"
    }
  }
}
