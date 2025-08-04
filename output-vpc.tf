output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.soley.id
}

output "public_subnet1_id" {
  description = "The ID of the first public subnet"
  value       = aws_subnet.soley-public-subnet-1.id
}

output "public_subnet2_id" {
  description = "The ID of the second public subnet"
  value       = aws_subnet.soley-public-subnet-2.id
}

output "private_subnet1_id" {
  description = "The ID of the first private subnet"
  value       = aws_subnet.soley-private-subnet-1.id
}

output "private_subnet2_id" {
  description = "The ID of the second private subnet"
  value       = aws_subnet.soley-private-subnet-2.id
}
