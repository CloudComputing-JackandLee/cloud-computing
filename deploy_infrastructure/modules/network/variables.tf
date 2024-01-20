variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "subnet_private_cidr_block" {
  description = "CIDR block for the private subnet"
}

variable "subnet_public_cidr_block" {
  description = "CIDR block for the public subnet"
}

variable "availability_zone_private" {
  description = "Availability zone for the private subnet"
}

variable "availability_zone_public" {
  description = "Availability zone for the public subnet"
}

variable "web_sg_id" {
  description = "ID of the web_sg security group"
}