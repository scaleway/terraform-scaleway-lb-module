<!-- BEGIN_TF_DOCS -->
# Scaleway Load Balancer Terraform module

Terraform module that can be used to deploy Load Balancer resources on Scaleway. Common deployment examples can be found in [examples/](./examples).

## Usage

The example below provision a basic Load Balancer.

``` hcl
module "lb" {
  source                          = "scaleway/lb-module/scaleway"
  zone                            = local.zone
  name                            = local.name
  tags                            = local.tags
  create_acls                     = true
  create_routes                   = true
  load_balancer_action_rules      = local.load_balancer_action_rules
  load_balancer_route_host_header = local.load_balancer_route_host_header
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement\_scaleway) | >= 2.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_scaleway"></a> [scaleway](#provider\_scaleway) | 2.21.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [scaleway_lb.main](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/lb) | resource |
| [scaleway_lb_acl.acls](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/lb_acl) | resource |
| [scaleway_lb_backend.backend](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/lb_backend) | resource |
| [scaleway_lb_frontend.frontend](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/lb_frontend) | resource |
| [scaleway_lb_ip.main](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/lb_ip) | resource |
| [scaleway_lb_route.route](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/lb_route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_failover_host"></a> [backend\_failover\_host](#input\_backend\_failover\_host) | Scaleway S3 bucket website to be served in case all backend servers are down | `string` | `null` | no |
| <a name="input_backend_forward_port"></a> [backend\_forward\_port](#input\_backend\_forward\_port) | Port to be used on load balancer backend resource as forward port | `number` | `80` | no |
| <a name="input_backend_forward_protocol"></a> [backend\_forward\_protocol](#input\_backend\_forward\_protocol) | Protocol to be used on load balancer backend resource | `string` | `"tcp"` | no |
| <a name="input_backend_health_check_delay"></a> [backend\_health\_check\_delay](#input\_backend\_health\_check\_delay) | Define maximum health check | `string` | `"1m0s"` | no |
| <a name="input_backend_health_check_max_retries"></a> [backend\_health\_check\_max\_retries](#input\_backend\_health\_check\_max\_retries) | Number of allowed failed HC requests before the backend server is marked down | `number` | `2` | no |
| <a name="input_backend_health_check_port"></a> [backend\_health\_check\_port](#input\_backend\_health\_check\_port) | The port to use when connecting to a backend server to forward a user session | `number` | `80` | no |
| <a name="input_backend_ignore_ssl_server_verify"></a> [backend\_ignore\_ssl\_server\_verify](#input\_backend\_ignore\_ssl\_server\_verify) | Specifies whether the Load Balancer should check the backend server’s certificate before initiating a connection | `bool` | `false` | no |
| <a name="input_backend_ip_addresses"></a> [backend\_ip\_addresses](#input\_backend\_ip\_addresses) | Backend server IP addresses list (IPv4 or IPv6) | `list(string)` | `[]` | no |
| <a name="input_backend_marked_down_action"></a> [backend\_marked\_down\_action](#input\_backend\_marked\_down\_action) | Modify what occurs when a backend server is marked down | `string` | `"none"` | no |
| <a name="input_backend_name"></a> [backend\_name](#input\_backend\_name) | The backend name of the load balancer. | `string` | `null` | no |
| <a name="input_backend_port_algorithm"></a> [backend\_port\_algorithm](#input\_backend\_port\_algorithm) | Load balancing algorithm | `string` | `"roundrobin"` | no |
| <a name="input_backend_proxy_protocol"></a> [backend\_proxy\_protocol](#input\_backend\_proxy\_protocol) | Type of PROXY protocol to enable | `string` | `"none"` | no |
| <a name="input_backend_ssl_bridging"></a> [backend\_ssl\_bridging](#input\_backend\_ssl\_bridging) | Enables SSL between load balancer and backend servers | `bool` | `false` | no |
| <a name="input_backend_sticky_sessions"></a> [backend\_sticky\_sessions](#input\_backend\_sticky\_sessions) | The type of sticky session | `string` | `null` | no |
| <a name="input_backend_sticky_sessions_cookie_name"></a> [backend\_sticky\_sessions\_cookie\_name](#input\_backend\_sticky\_sessions\_cookie\_name) | Cookie name for for sticky sessions | `string` | `null` | no |
| <a name="input_backend_timeout_connect"></a> [backend\_timeout\_connect](#input\_backend\_timeout\_connect) | Define maximum timeout for server | `string` | `"2.5s"` | no |
| <a name="input_backend_timeout_health_check"></a> [backend\_timeout\_health\_check](#input\_backend\_timeout\_health\_check) | Define maximum health check | `string` | `"30s"` | no |
| <a name="input_backend_timeout_server"></a> [backend\_timeout\_server](#input\_backend\_timeout\_server) | Define maximum timeout for server | `string` | `"1s"` | no |
| <a name="input_backend_timeout_tunnel"></a> [backend\_timeout\_tunnel](#input\_backend\_timeout\_tunnel) | Define maximum timeout for tunnel | `string` | `"3s"` | no |
| <a name="input_certificate_ids"></a> [certificate\_ids](#input\_certificate\_ids) | Certificate IDs list | `list(string)` | `null` | no |
| <a name="input_create_acls"></a> [create\_acls](#input\_create\_acls) | Controls if the Load Balancer ACl Rules should be created | `bool` | `true` | no |
| <a name="input_create_lb"></a> [create\_lb](#input\_create\_lb) | Controls if the Load Balancer should be created | `bool` | `true` | no |
| <a name="input_create_routes"></a> [create\_routes](#input\_create\_routes) | Determines if route should be created | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Define a description for the Load balancer | `string` | `null` | no |
| <a name="input_frontend_inbound_port"></a> [frontend\_inbound\_port](#input\_frontend\_inbound\_port) | Port to be used on load balancer frontend resource as inbound port | `number` | `443` | no |
| <a name="input_frontend_name"></a> [frontend\_name](#input\_frontend\_name) | Name to be used on load balancer frontend resource as identifier | `string` | `""` | no |
| <a name="input_frontend_timeout_client"></a> [frontend\_timeout\_client](#input\_frontend\_timeout\_client) | Defines maximum allowed inactivity time on the client side | `string` | `"30s"` | no |
| <a name="input_load_balancer_action_rules"></a> [load\_balancer\_action\_rules](#input\_load\_balancer\_action\_rules) | A list of maps describing the ACL Rules for this LB. Required key/values: actions, rules. (default to load\_balancer\_action\_rules[count.index]) | `any` | `[]` | no |
| <a name="input_load_balancer_backend_health_check"></a> [load\_balancer\_backend\_health\_check](#input\_load\_balancer\_backend\_health\_check) | A list of maps describing the Health check method for this LB. Required key/values: type: https. Required: uri Optional: code, sni. (default to load\_balancer\_backend\_health\_check[count.index] | `any` | <pre>[<br>  {<br>    "methods": [<br>      {<br>        "type": "https"<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_load_balancer_name"></a> [load\_balancer\_name](#input\_load\_balancer\_name) | The resource name of the load balancer. | `string` | `""` | no |
| <a name="input_load_balancer_route_host_header"></a> [load\_balancer\_route\_host\_header](#input\_load\_balancer\_route\_host\_header) | A list of maps describing the load balancer routes. Optional match\_sni, match\_host\_header. Conditions must be based on SNI for direction to TCP backends, or HTTP host headers for direction to HTTP backends. Use the routes endpoint to create, edit, list, get and delete your routes. | `any` | `[]` | no |
| <a name="input_load_balancer_tags"></a> [load\_balancer\_tags](#input\_load\_balancer\_tags) | Additional tags for the VPC | `list(string)` | `[]` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The type of load balancer to create. Possible types: lb-s, lb-gp-m, lb-gp-l, lb-gp-xl | `string` | `"LB-S"` | no |
| <a name="input_name"></a> [name](#input\_name) | The resource name of the load balancer. | `string` | `"scaleway-lb-module"` | no |
| <a name="input_private_network_configs"></a> [private\_network\_configs](#input\_private\_network\_configs) | List of private networks configurations | <pre>list(object({<br>    private_network = object({<br>      id           = string<br>      dhcp_enabled = bool<br>      static_ips   = list(string)<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_ssl_compatibility_level"></a> [ssl\_compatibility\_level](#input\_ssl\_compatibility\_level) | Determines the minimal SSL version which needs to be supported on client side. | `string` | `"ssl_compatibility_level_modern"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags to add to all resources | `list(string)` | `[]` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Define maximum timeout for creating, updating, and deleting load balancer resources | `map(string)` | `{}` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Load balancer zone | `string` | `"fr-par-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_load_balancer_backend_pool"></a> [load\_balancer\_backend\_pool](#output\_load\_balancer\_backend\_pool) | List of IP addresses of backend servers attached to this backends |
| <a name="output_load_balancer_ids"></a> [load\_balancer\_ids](#output\_load\_balancer\_ids) | Load balancer UUIDs |
| <a name="output_load_balancer_ip_addresses"></a> [load\_balancer\_ip\_addresses](#output\_load\_balancer\_ip\_addresses) | Load balancer IP addresses |
| <a name="output_load_balancer_ip_reverse"></a> [load\_balancer\_ip\_reverse](#output\_load\_balancer\_ip\_reverse) | List of reverse of the load balancer IP |

## Refresh documentation

To create the Readme.md, we use [Terraform-docs](https://terraform-docs.io/). The configuration is in the file `.terraform-docs.yml`.
If you want to refresh the `Readme.md`, from the root of the module execute the following command:

``` shell
terraform-docs .
```
<!-- END_TF_DOCS -->
