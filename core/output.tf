# VPC
output "vpc_id" {
  value = aws_vpc.vpc.id
}

# 퍼블릭 서브넷 AZ-a
output "public_subnet1_a" {
  value = aws_subnet.public_subnet1_a.id
}

# 퍼블릭 서브넷 AZ-c
output "public_subnet1_c" {
  value = aws_subnet.public_subnet1_c.id
}

# 프라이빗 서브넷 AZ-a (WAS)
output "private_subnet1_a" {
  value = aws_subnet.private_subnet1_a.id
}

# 프라이빗 서브넷 AZ-c (WAS)
output "private_subnet1_c" {
  value = aws_subnet.private_subnet1_c.id
}

# 프라이빗 서브넷 AZ-a (RDS)
output "private_subnet2_a" {
  value = aws_subnet.private_subnet2_a.id
}

# 프라이빗 서브넷 AZ-c (RDS)
output "private_subnet2_c" {
  value = aws_subnet.private_subnet2_c.id
}

# NAT 보안 그룹
output "security_group_nat" {
  value = aws_security_group.nat_sg.id
}
