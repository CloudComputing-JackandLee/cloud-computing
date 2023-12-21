
resource "docker_image" "socket_server_image" {
  name          = var.socket_server_image_name
  build_context = "${path.module}/Server"
}

resource "docker_image" "react_app_image" {
  name          = var.react_app_image_name
  build_context = path.module
}

resource "docker_registry_image" "socket_server_registry_image" {
  name          = var.socket_server_image_name
  remote        = "${var.registry_url}/${var.socket_server_image_name}"
  build         = true
  build_context = "${path.module}/Server"
}

resource "docker_registry_image" "react_app_registry_image" {
  name          = var.react_app_image_name
  remote        = "${var.registry_url}/${var.react_app_image_name}"
  build         = true
  build_context = "${path.module}"
}
