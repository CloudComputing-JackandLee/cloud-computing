# variables.tf

# Define input variables used in the main configuration and modules.

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}
variable "aws_secret_key"{
  description = "AWS secret key"
  type        = string
}
variable "aws_token"  {
  description = "AWS token"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

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

