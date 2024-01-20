output "alb_hostname" {
  value = module.load_balancer.lb_dns_name
}
output "socket_hostname" {
  value = module.socket_load_balancer.lb_dns_name
}