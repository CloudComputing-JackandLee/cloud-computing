# main.tf
# Use the ecs_cluster module to create an ECS cluster.
module "ecs_cluster" {
  source = "./modules/ecs_cluster"

  # Pass necessary variables to the module
  cluster_name = var.cluster_name
}

# Use the react_app module to create resources for the React app.
module "react_app" {
  source = "./modules/react_app"

  # Pass necessary variables to the module
  ecr_repository_name = var.ecr_repository_name
  task_cpu            = var.task_cpu
  task_memory         = var.task_memory
}










terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.66.1"
    }
  }

  required_version = ">= 1.5.5"
}

provider "aws" {
  region = "us-east-1"
  # Authentication requires the following environment variables:
  #     AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_SESSION_TOKEN
}

resource "aws_security_group" "sg_bottletube_ec2" {
  name        = "sg_bottletube_ec2"
}

resource "aws_security_group_rule" "allow_ssh_traffic_to_ec2" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_bottletube_ec2.id
}

# TODO: Erlauben Sie http traffic für sg_bottletube_ec2
resource "aws_security_group_rule" "allow_http_traffic_to_ec2" {

}

resource "aws_security_group_rule" "allow_all_outbound_traffic_from_ec2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_bottletube_ec2.id
}

# TODO: Erstellen Sie eine Security Group "sg_bottletube_rds", die nur postgres traffic von sg_bottletube_ec2 erlaubt

resource "aws_key_pair" "bottletube" {
  key_name   = "bottletube"
  public_key = "" # TODO: Ergänzen Sie hier Ihren public key (Hinweise in den Folien)
}

# verleiht der EC2 Instanz die nötigen Rechte, auf andere Services zuzugreifen (bereitgestellt durch das learner lab)
data "aws_iam_instance_profile" "vocareum_lab_instance_profile" {
  name = "LabInstanceProfile"
}

resource "aws_instance" "bottletube" {
  depends_on = [
    aws_db_instance.bottletube,
    aws_s3_bucket.bottletube,
    aws_cloudfront_distribution.bottletube
  ]
  ami                         = "ami-053b0d53c279acc90"  # Ubuntu, 22.04 LTS
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.sg_bottletube_ec2.id]
  associate_public_ip_address = true
  # TODO: Weisen Sie der Instanz das key pair und das instance profile zu
}

variable "S3_BUCKET_ID_PREFIX" {
  type    = string
  default = ""
}

resource "aws_s3_bucket" "bottletube" {
  bucket_prefix = var.S3_BUCKET_ID_PREFIX
  force_destroy = true  # needed to destroy buckets containing objects
}

resource "aws_s3_bucket_public_access_block" "bottletube" {
  bucket = aws_s3_bucket.bottletube.id

  # first to settings are needed to upload the publicly accessible bottletube_banner.jpeg
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "bottletube" {
  # TODO: Verleihen Sie dem s3 bucket die Regel "BucketOwnerPreferred"
}

resource "aws_s3_object" "bottletube_user_uploads_directory" {
  bucket = aws_s3_bucket.bottletube.id
  key    = "user_uploads/"
}


resource "aws_s3_object" "bottletube_static_content_directory" {
  # TODO: Legen Sie ein weiteres Verzeichnis "static/" an
}

resource "aws_s3_object" "bottletube_banner" {
  # TODO: Konfigurieren Sie das object so, dass es erst erstellt wird, wenn der public access block, die ownership controls und das static content directory erstellt wurden
  bucket = aws_s3_bucket.bottletube.id
  acl    = "public-read"
  key    = "/static/bottletube_banner.jpeg"
  source = "bottletube_banner.jpeg"
}

locals {
  s3_origin_id = "BottletubeS3BucketOrigin"
}

resource "aws_cloudfront_distribution" "bottletube" {
  origin {
    domain_name = aws_s3_bucket.bottletube.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    origin_path = "/static"
  }

  enabled             = true
  is_ipv6_enabled     = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # TODO: Ergänzen Sie die restrictions so, dass Inhalte nur in der USA und in Deutschland verteilt werden
  restrictions {

  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

variable "BOTTLETUBE_RDS_PASSWORD" {
  type    = string
  default = ""
  sensitive = true
}

resource "aws_secretsmanager_secret" "bottletube_rds_password" {
  name = "BOTTLETUBE_RDS_PASSWORD"
  recovery_window_in_days = 0  # needed to allow immediate deletion and recreation when applying the configuration
}

# TODO: Legen Sie eine aws_secretsmanager_secret_version für das aws_secretsmanager_secret an
# TODO: Verwenden Sie dabei die Variable "BOTTLETUBE_RDS_PASSWORD"

resource "aws_db_instance" "bottletube" {
  identifier             = "bottletube"
  db_name                = "bottletube"
  username               = "postgres"
  # TODO: Geben Sie hier das RDS Passwort an
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.6"
  instance_class         = "db.t3.micro"
  parameter_group_name   = "default.postgres14"
  skip_final_snapshot    = true
  # TODO: Verhindern Sie den öffentlichen Zugriff auf die RDS Instanz
  # TODO: Weise Sie die RDS Instanz der entsprechenden Security Group zu
}

output "BOTTLETUBE_EC2_HOST_DNS_NAME" {
  value = aws_instance.bottletube.public_dns
}

output "BOTTLETUBE_RDS_HOST" {
  value = split(":", aws_db_instance.bottletube.endpoint)[0]
}

output "BOTTLETUBE_S3_BUCKET_ID" {
  value = aws_s3_bucket.bottletube.id
}

output "BOTTLETUBE_CLOUDFRONT_DOMAIN_NAME" {
  value = aws_cloudfront_distribution.bottletube.domain_name
}