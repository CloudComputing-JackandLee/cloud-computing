
output "ecs_tasks_security_group_id" {
  value = aws_security_group.web_sg.id
}