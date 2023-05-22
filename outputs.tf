output "load_balancer_ip_addresses" {
  description = "Load balancer IP addresses"
  value       = try(scaleway_lb.main.ip_address, null)
}

output "load_balancer_ip_reverse" {
  description = "List of reverse of the load balancer IP"
  value       = try(scaleway_lb_ip.main.reverse, null)
}

output "load_balancer_ids" {
  value       = try(scaleway_lb.main.id, null)
  description = "Load balancer UUIDs"
}

output "load_balancer_backend_pool" {
  description = "List of IP addresses of backend servers attached to this backends"
  value       = try(scaleway_lb_backend.backend.server_ips, null)
}
