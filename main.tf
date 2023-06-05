################################################################################
# LOAD BALANCER
################################################################################

resource "scaleway_lb_backend" "backend" {
  name                        = lower(coalesce(var.backend_name, var.name))
  lb_id                       = scaleway_lb.main.id
  forward_protocol            = var.backend_forward_protocol
  forward_port                = var.backend_forward_port
  forward_port_algorithm      = var.backend_port_algorithm
  sticky_sessions             = var.backend_sticky_sessions
  sticky_sessions_cookie_name = var.backend_sticky_sessions_cookie_name
  server_ips                  = var.backend_ip_addresses
  timeout_connect             = var.backend_timeout_connect
  timeout_server              = var.backend_timeout_server
  timeout_tunnel              = var.backend_timeout_tunnel
  health_check_timeout        = var.backend_timeout_health_check
  health_check_delay          = var.backend_health_check_delay
  ssl_bridging                = var.backend_ssl_bridging
  ignore_ssl_server_verify    = var.backend_ignore_ssl_server_verify
  failover_host               = var.backend_failover_host
  health_check_max_retries    = var.backend_health_check_max_retries
  health_check_port           = var.backend_health_check_port
  proxy_protocol              = var.backend_proxy_protocol
  on_marked_down_action       = var.backend_marked_down_action
  health_check_tcp {}
}

resource "scaleway_lb_frontend" "frontend" {
  name            = lower(coalesce(var.frontend_name, var.name))
  lb_id           = scaleway_lb.main.id
  backend_id      = scaleway_lb_backend.backend.id
  inbound_port    = var.frontend_inbound_port
  timeout_client  = var.frontend_timeout_client
  certificate_ids = var.certificate_ids
  external_acls   = true
}

### LB IP
resource "scaleway_lb_ip" "main" {
  zone = var.zone
}

### LOAD BALANCER
resource "scaleway_lb" "main" {
  ip_id       = scaleway_lb_ip.main.id
  name        = lower(coalesce(var.load_balancer_name, var.name))
  description = var.description
  type        = var.load_balancer_type

  dynamic "private_network" {
    for_each = var.private_network_configs
    content {
      private_network_id = private_network.value["private_network_id"]
      dhcp_config        = private_network.value["dhcp_config"]
      static_config      = private_network.value["static_ips"]
    }
  }

  ssl_compatibility_level = var.ssl_compatibility_level
  tags = concat(
    var.tags,
    var.load_balancer_tags,
  )
  zone = var.zone
  timeouts {
    create = lookup(var.timeouts, "create", "10m")
    update = lookup(var.timeouts, "update", "10m")
    delete = lookup(var.timeouts, "delete", "10m")
  }
}

################################################################################
# LOAD BALANCER ROUTES
################################################################################

resource "scaleway_lb_route" "route" {
  count             = var.create_routes ? length(var.load_balancer_route_host_header) : 0
  frontend_id       = scaleway_lb_frontend.frontend.id
  backend_id        = scaleway_lb_backend.backend.id
  match_host_header = try(var.load_balancer_route_host_header[count.index].match_host_header, null)
  match_sni         = try(var.load_balancer_route_host_header[count.index].match_sni, null)
}

################################################################################
# LOAD BALANCER ACL
################################################################################

resource "scaleway_lb_acl" "acls" {
  count       = var.create_acls ? length(var.load_balancer_action_rules) : 0
  frontend_id = scaleway_lb_frontend.frontend.id
  name        = try(var.load_balancer_action_rules[count.index].name, null)
  description = try(lower(var.load_balancer_action_rules[count.index].description), null)
  index       = try(lower(var.load_balancer_action_rules[count.index].index), count.index)

  dynamic "action" {
    for_each = [
      for action_rule in var.load_balancer_action_rules[count.index].actions :
      action_rule
      if action_rule.type == "allow"
    ]

    content {
      type = action.value["type"]
    }
  }

  dynamic "action" {
    for_each = [
      for action_rule in var.load_balancer_action_rules[count.index].actions :
      action_rule
      if action_rule.type == "deny"
    ]

    content {
      type = action.value["type"]
    }
  }

  # redirect actions
  dynamic "action" {
    for_each = [
      for action_rule in var.load_balancer_action_rules[count.index].actions :
      action_rule
      if action_rule.type == "redirect"
    ]

    content {
      type = action.value["type"]
      dynamic "redirect" {
        for_each = action.value["redirect"]
        content {
          type   = lookup(redirect.value, "type", null)
          target = lookup(redirect.value, "target", null)
          code   = try(redirect.value["code"], null)
        }
      }
    }
  }

  dynamic "match" {
    for_each = [
      for match_rule in var.load_balancer_action_rules[count.index].rules :
      match_rule
      if match_rule.type == "path_begin"
    ]

    content {
      ip_subnet         = try(match.value["ip_subnet"], null)
      http_filter_value = try(match.value["http_filter_value"], null)
      http_filter       = try(match.value["http_filter"], null)
      invert            = try(match.value["invert"], null)
    }
  }
}
