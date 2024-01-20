output "alb_hostname" {
  value = "${aws_lb.ecs_lb.dns_name}:80"
}
output "alb_hostname2" {
  value = aws_lb.ecs_lb.dns_name
}

output "service" {
  value = aws_ecs_task_definition.ecs_task_definition.network_mode
}