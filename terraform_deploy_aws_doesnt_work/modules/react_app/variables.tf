# modules/react_app/variables.tf

# Define input variables for the react_app module.

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for ECS tasks"
  type        = string
}

variable "task_memory" {
  description = "Memory for ECS tasks"
  type        = string
}
