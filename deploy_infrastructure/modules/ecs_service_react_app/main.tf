
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                    = var.task_family
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = 256
  memory                    = 512
  execution_role_arn        = var.execution_role_arn
  task_role_arn             = var.task_role_arn

  container_definitions = jsonencode([
    {
      name        = "connect4"
      image       = var.connect4_container_image
      essential   = true
      portMappings = [{
        protocol      = "http"
        containerPort = var.connect4_container_port
        hostPort      = var.connect4_container_port
      }]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "connect4_service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = "connect4"
    container_port   = var.connect4_container_port
  }

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
    security_groups  = [var.security_group_id]
  }
}