output "subnet_ids" {
  value = [aws_subnet.private.id, aws_subnet.public.id]
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "ecr_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}

output "ecr_token_proxy_endpoint" {
  value = data.aws_ecr_authorization_token.token.proxy_endpoint
}
output "ecr_token_username" {
  sensitive = true
  value = data.aws_ecr_authorization_token.token.user_name
}
output "ecr_token_password" {
  sensitive = true
  value = data.aws_ecr_authorization_token.token.password
}