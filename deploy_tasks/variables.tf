/*
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
*/

variable "socket_container_image" {
  description = "Image for the socket container"
}

variable "connect4_container_image" {
  description = "Image for the connect4 container"
}

variable "socket_container_port" {
  description = "Port for the socket container"
  default     = 3001
}

variable "connect4_container_port" {
  description = "Port for the connect4 container"
  default     = 80
}