################################################################################
# General
################################################################################

variable "name" {
  description = "The resource name of the load balancer."
  type        = string
  default     = " "
}

variable "description" {
  description = "Define a description for the Load balancer"
  type        = string
  default     = null
}

variable "tags" {
  description = "A list of tags to add to all resources"
  type        = list(string)
  default     = []
}

variable "zone" {
  description = "Load balancer zone"
  type        = string
  default     = "fr-par-1"
}

################################################################################
# Load balancer
################################################################################

variable "load_balancer_name" {
  description = "The resource name of the load balancer."
  type        = string
  default     = ""
}

variable "load_balancer_tags" {
  description = "Additional tags for the VPC"
  type        = list(string)
  default     = []
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting load balancer resources"
  type        = map(string)
  default     = {}
}

variable "ssl_compatibility_level" {
  description = "Determines the minimal SSL version which needs to be supported on client side."
  type        = string
  default     = "ssl_compatibility_level_modern"
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible types: lb-s, lb-gp-m, lb-gp-l, lb-gp-xl"
  type        = string
  default     = "LB-S"
}

variable "private_network_configs" {
  description = "List of private networks configurations"
  type = list(object({
    private_network = object({
      id           = string
      dhcp_enabled = bool
      static_ips   = list(string)
    })
  }))
  default = []
}

################################################################################
# Backend
################################################################################

variable "backend_name" {
  description = "The backend name of the load balancer."
  type        = string
  default     = null
}

variable "backend_forward_protocol" {
  description = "Protocol to be used on load balancer backend resource"
  type        = string
  default     = "tcp"
}

variable "backend_forward_port" {
  description = "Port to be used on load balancer backend resource as forward port"
  type        = number
  default     = 80
}

variable "backend_ip_addresses" {
  description = "Backend server IP addresses list (IPv4 or IPv6)"
  default     = []
  type        = list(string)
}

variable "backend_sticky_sessions" {
  description = "The type of sticky session"
  default     = null
  type        = string
}

variable "backend_sticky_sessions_cookie_name" {
  description = "Cookie name for for sticky sessions"
  default     = null
  type        = string
}

variable "backend_port_algorithm" {
  description = "Load balancing algorithm"
  default     = "roundrobin"
  type        = string
}

variable "backend_timeout_server" {
  description = "Define maximum timeout for server"
  type        = string
  default     = "1s"
}

variable "backend_timeout_connect" {
  description = "Define maximum timeout for server"
  type        = string
  default     = "2.5s"
}

variable "backend_timeout_tunnel" {
  description = "Define maximum timeout for tunnel"
  type        = string
  default     = "3s"
}

variable "backend_timeout_health_check" {
  description = "Define maximum health check"
  type        = string
  default     = "30s"
}

variable "backend_failover_host" {
  description = "Scaleway S3 bucket website to be served in case all backend servers are down"
  type        = string
  default     = null
}

variable "backend_health_check_max_retries" {
  description = "Number of allowed failed HC requests before the backend server is marked down"
  type        = number
  default     = 2
}

variable "backend_health_check_delay" {
  description = "Define maximum health check"
  type        = string
  default     = "1m0s"
}

variable "backend_marked_down_action" {
  description = "Modify what occurs when a backend server is marked down"
  type        = string
  default     = "none"
}

variable "backend_ssl_bridging" {
  description = "Enables SSL between load balancer and backend servers"
  type        = bool
  default     = false
}

variable "backend_ignore_ssl_server_verify" {
  description = "Specifies whether the Load Balancer should check the backend server’s certificate before initiating a connection"
  type        = bool
  default     = false
}

variable "backend_health_check_port" {
  default     = 80
  type        = number
  description = "The port to use when connecting to a backend server to forward a user session"
}

variable "backend_proxy_protocol" {
  default     = "none"
  type        = string
  description = "Type of PROXY protocol to enable"
}

################################################################################
# Frontend
################################################################################

variable "frontend_name" {
  default     = ""
  type        = string
  description = "Name to be used on load balancer frontend resource as identifier"
}

variable "frontend_inbound_port" {
  default     = 443
  type        = number
  description = "Port to be used on load balancer frontend resource as inbound port"
}

variable "frontend_timeout_client" {
  default     = "30s"
  type        = string
  description = "Defines maximum allowed inactivity time on the client side"
}

################################################################################
# Certificate
################################################################################

variable "certificate_ids" {
  description = "Certificate IDs list"
  default     = null
  type        = list(string)
}
