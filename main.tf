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
}

### IP for LB
resource "scaleway_lb_ip" "main" {
  zone = var.zone
}

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

variable "load_balancer_route_host_header" {
  description = "Security group rules to add to the security group created"
  type        = any
  default     = {}
}

variable "create_routes" {
  description = "Determines if route should be created"
  type        = bool
  default     = false
}

################################################################################
# LOAD BALANCER ROUTES
################################################################################

resource "scaleway_lb_route" "route" {
  for_each = {
    for k, v in var.load_balancer_route_host_header : k => v
    if var.create_routes
  }
  frontend_id       = scaleway_lb_frontend.frontend.id
  backend_id        = scaleway_lb_backend.backend.id
  match_host_header = lookup(each.value, "match_host_header", null)
  match_sni         = lookup(each.value, "match_sni", null)
}
