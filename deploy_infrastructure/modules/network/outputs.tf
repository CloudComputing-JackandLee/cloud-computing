output "subnet_ids" {
  value = [aws_subnet.private.id, aws_subnet.public.id]
}

output "vpc_id" {
  value = aws_vpc.main.id
}