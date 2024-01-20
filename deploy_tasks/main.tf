module "ecs_service" {
  source                 = "./modules/ecs_service_react_app"
  task_family            = "service"
  cluster_name           = "connect4-cluster"
  execution_role_arn     = data.aws_iam_role.LabRole.arn
  task_role_arn          = data.aws_iam_role.LabRole.arn
  subnet_ids             = module.network.subnet_ids
  lb_target_group_arn    = module.load_balancer.lb_target_arn
  security_group_id      = module.security.ecs_tasks_security_group_id
  connect4_container_image  = var.connect4_container_image
  connect4_container_port   = var.connect4_container_port

}
module "ecs_service_socket" {
  source                 = "./modules/ecs_service_socket"
  task_family            = "service-socket"
  cluster_name           = "connect4-cluster"
  execution_role_arn     = data.aws_iam_role.LabRole.arn
  task_role_arn          = data.aws_iam_role.LabRole.arn
  subnet_ids             = module.network.subnet_ids
  lb_target_group_arn    = module.socket_load_balancer.lb_target_arn
  security_group_id      = module.security.ecs_tasks_security_group_id
  socket_container_image    = var.socket_container_image
  socket_container_port     = var.socket_container_port
}