# modules/react_app/main.tf

# Define resources for creating an ECR repository and other resources for the React app ECS task.

resource "aws_ecr_repository" "docker_repo" {
  name = var.ecr_repository_name
}

# Define other resources for your React app ECS task here
