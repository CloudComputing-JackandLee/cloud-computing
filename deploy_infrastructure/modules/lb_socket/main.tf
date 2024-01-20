resource "aws_lb" "ecs_lb" {
  name               = var.lb_name
  internal           = var.internal_lb
  load_balancer_type = "application"
  security_groups    = [var.web_sg_id]
  subnets            = var.subnets
}

resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 3001
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "ecs_target_group" {
  name     = "socket-ecs-target-group"
  port     = 3001
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}