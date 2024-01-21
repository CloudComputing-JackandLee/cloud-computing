data "aws_iam_role" "LabRole" {
  name = "LabRole"
}

module "network" {
  source = "./modules/network"

  vpc_cidr_block           = "10.0.0.0/16"
  subnet_private_cidr_block = "10.0.1.0/24"
  subnet_public_cidr_block  = "10.0.0.0/24"
  availability_zone_private = "us-east-1b"
  availability_zone_public  = "us-east-1a"
  web_sg_id                 = module.security.ecs_tasks_security_group_id
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}
module "load_balancer" {
  source       = "./modules/lb_react_app"
  lb_name      = "ecs-lb"
  internal_lb  = false
  subnets      = module.network.subnet_ids
  web_sg_id    = module.security.ecs_tasks_security_group_id
  vpc_id = module.network.vpc_id
}

module "socket_load_balancer" {
  source       = "./modules/lb_socket"
  lb_name      = "socket-ecs-lb"
  internal_lb  = false
  subnets      = module.network.subnet_ids
  web_sg_id    = module.security.ecs_tasks_security_group_id
  vpc_id = module.network.vpc_id
}

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
