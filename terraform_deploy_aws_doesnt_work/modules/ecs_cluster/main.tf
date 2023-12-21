# modules/ecs_cluster/main.tf

# Define resources for creating an ECS cluster.

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}
