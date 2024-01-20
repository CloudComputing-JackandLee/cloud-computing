output "lb_dns_name" {
  value = aws_lb.ecs_lb.dns_name
}

output "lb_target_arn" {
  value = aws_lb_target_group.ecs_target_group.arn
}