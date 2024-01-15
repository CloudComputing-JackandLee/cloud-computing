# modules/ecs_cluster/main.tf






data "aws_iam_role" "LabRole" {
  name = "LabRole"
}

data "aws_iam_instance_profile" "vocareum_lab_instance_profile" {
  name = "LabInstanceProfile"
}

# Define resources for creating an ECS cluster.

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  tags = {
    Name = "connect4-change"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "connect4"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "connect4-private-1"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "connect4-public-1"
  }
}




resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "connect4-public2"
  }

}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.main]
}

resource "aws_eip" "nat" {
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "alb" {
  name   = "secure-vpc"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }



  ingress {
    protocol         = "tcp"
    from_port        = 3001
    to_port          = 3001
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name   = "secure-ecs"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 3001
    to_port          = 3001
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  name        = "web_sg"
  description = "Security group for web instances"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol         = "tcp"
    from_port        = 3001
    to_port          = 3001
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

/*resource "aws_ecr_repository" "cloud-computing-block" {
  name = "cloud-computing-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    env = "dev"
    name = "cloud computing repo"
  }
}*/

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

}


resource "aws_lb" "ecs_lb" {
  name               = "ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.private.id]
}

resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "ecs_target_group" {
  name     = "ecs-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  target_type = "ip"
}



resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn = data.aws_iam_role.LabRole.arn
  task_role_arn = data.aws_iam_role.LabRole.arn



  container_definitions = jsonencode([{
    name        = "connect4"
    image       = "jackainsworth/connect4:v1.2"
    essential   = true
    portMappings = [{
      protocol      = "http"
      containerPort = 80
      hostPort      = 80
    }]
  }, {
    name        = "socket"
    image       = "jackainsworth/cloud-computing-socket-server:v1.2"
    essential   = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 3001
      hostPort      = 3001
    }]
  }])
}
resource "aws_ecs_service" "service" {
  name            = "connect4_service"
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count = 1
  launch_type = "FARGATE"
/*
  security_groups = [aws_security_group.ecs_tasks.arn]
*/
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "connect4"
    container_port   = 80
  }

  network_configuration {
    subnets = [aws_subnet.public.id]
    assign_public_ip = true
    security_groups = [aws_security_group.ecs_tasks.id]

  }
}

