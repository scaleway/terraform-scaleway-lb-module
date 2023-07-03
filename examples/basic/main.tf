provider "scaleway" {
  region = local.region
  zone   = local.zone
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "fr-par"
  zone   = "fr-par-1"
  tags = [
    local.name,
    "terraform-scaleway-lb-module"
  ]

  load_balancer_backend_health_check = {
    type        = "https"
    uri         = "https://test.com/health"
    method      = "GET"
    code        = 200
    host_header = "test.com"
    sni         = "sni.test.com"
  }

  load_balancer_action_rules = [
    {
      name = "name-acl"
      actions = [
        {
          type = "allow"
          name = "test"
        }
      ]
      "rules" = [
        {
          "type" : "path_begin",
          ip_subnet         = ["0.0.0.0/0"]
          http_filter       = "acl_http_filter_none"
          http_filter_value = []
        },
      ]
    }
  ]
}

################################################################################
# LB Module
################################################################################

module "lb" {
  source                                   = "../../"
  zone                                     = local.zone
  name                                     = local.name
  tags                                     = local.tags
  create_acls                              = true
  create_routes                            = true
  load_balancer_action_rules               = local.load_balancer_action_rules
  load_balancer_backend_health_check_https = local.load_balancer_backend_health_check
}
