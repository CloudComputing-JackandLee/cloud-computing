variable "registry_url" {
  description = "Docker registry URL"
}

variable "socket_server_image_name" {
  description = "Name of the Docker image for the socket server"
  default     = "socket-server-image"
}

variable "react_app_image_name" {
  description = "Name of the Docker image for the React app"
  default     = "react-app-image"
}
