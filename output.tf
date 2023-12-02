output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id

}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.my_vpc.arn
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.IGW.id
}

output "public_subnets_web" {
  description = "List of IDs of public subnets"
  value       =aws_subnet.pub_subnet_web[*].id
}

output "private_subnet_app" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.Pri_subnet_app[*].id
}

output "private_subnet_DB" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.Private_sub_DB[*].id
}