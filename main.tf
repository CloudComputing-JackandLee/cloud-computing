module "deploy" {
  source = "./deploy_infrastructure"
  connect4_container_image = var.connect4_container_image
  socket_container_image = var.socket_container_image
  deploy_ecs_services = var.deploy_ecs_services
}