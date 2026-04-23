resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true # DNS 지원 활성화
  enable_dns_hostnames = true # DNS 호스트 이름 활성화

  tags = {
    Name = "Guestbook-VPC"
  }
}
