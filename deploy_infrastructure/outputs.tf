output "alb_hostname" {
  value = module.load_balancer.lb_dns_name
}
output "socket_hostname" {
  value = module.socket_load_balancer.lb_dns_name
}

output "ecr_token_proxy_endpoint" {
  value= module.network.ecr_token_proxy_endpoint
}
output "ecr_token_username" {
  sensitive = true
  value= module.network.ecr_token_username
}
output "ecr_token_password" {
  sensitive = true
  value= module.network.ecr_token_password
}