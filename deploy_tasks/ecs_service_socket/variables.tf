variable "cluster_name" {
  description = "Name of the ECS cluster"
}

variable "task_family" {
  description = "Family name for the ECS task definition"
}

variable "execution_role_arn" {
  description = "ARN of the execution role"
}

variable "task_role_arn" {
  description = "ARN of the task role"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ECS service"
  type        = list(string)
}

variable "lb_target_group_arn" {
  description = "ARN of the load balancer target group"
}

variable "security_group_id" {
  description = "ID of the security group for ECS tasks"
}

variable "socket_container_image" {
  description = "Image for the socket container"
}

variable "socket_container_port" {
  description = "Port for the socket container"
}
