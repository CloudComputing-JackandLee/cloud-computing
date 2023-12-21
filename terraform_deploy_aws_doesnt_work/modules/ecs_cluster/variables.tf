# modules/ecs_cluster/variables.tf

# Define input variables for the ecs_cluster module.

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}
