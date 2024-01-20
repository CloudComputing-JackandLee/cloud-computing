variable "lb_name" {
  description = "Name of the load balancer"
}

variable "internal_lb" {
  description = "Whether the load balancer is internal or not"
}

variable "subnets" {
  description = "List of subnets for the load balancer"
  type        = list(string)
}

variable "web_sg_id" {
  description = "ID of the web_sg security group"
}

variable "vpc_id" {
  description = "ID of the VPC"
}