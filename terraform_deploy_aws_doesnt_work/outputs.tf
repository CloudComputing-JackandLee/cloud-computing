output "alb_hostname" {
  value = module.ecs_cluster.alb_hostname
}
output "alb_hostname2" {
  value = module.ecs_cluster.alb_hostname2
}

output "service" {
  value = module.ecs_cluster.service
}