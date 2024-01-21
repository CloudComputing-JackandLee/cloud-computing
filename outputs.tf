output "alb_hostname" {
  value = module.deploy.alb_hostname
}
output "socket_hostname" {
  value = module.deploy.socket_hostname
}

/*
output "ecr_token_proxy_endpoint" {
  value= module.deploy.ecr_token_proxy_endpoint
}
output "ecr_token_username" {
  sensitive = true
  value= module.deploy.ecr_token_username
}
output "ecr_token_password" {
  sensitive = true
  value= module.deploy.ecr_token_password
}*/
