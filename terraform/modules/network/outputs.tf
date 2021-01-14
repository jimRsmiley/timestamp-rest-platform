output "vpc_id" {
  value = aws_vpc.default.id
}

output "app_subnet_ids" {
  value = aws_subnet.app.*.id
}
