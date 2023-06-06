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

  load_balancer_backend_health_check = [
    {
      methods = [
        {
          type = "tcp"
        }
      ]
    }
  ]


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

  load_balancer_route_host_header = [
    {
      match_sni = "sni.scaleway.com"
      #      match_host_header = "host.scaleway.com"
    }
  ]
}

################################################################################
# LB Module
################################################################################

module "lb" {
  source                             = "../../"
  zone                               = local.zone
  name                               = local.name
  tags                               = local.tags
  create_lb                          = true
  create_acls                        = true
  create_routes                      = true
  load_balancer_action_rules         = local.load_balancer_action_rules
  load_balancer_route_host_header    = local.load_balancer_route_host_header
  load_balancer_backend_health_check = local.load_balancer_backend_health_check
}
