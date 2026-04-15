# NAT 보안 그룹
resource "aws_security_group" "nat_sg" {
  name   = "nat-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "NAT-SG"
  }
}

# NAT 인바운드 - SSH(Only My IP)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_MyIP" {
  description       = "Allow SSH from only My IP"
  security_group_id = aws_security_group.nat_sg.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "${var.my_ip}/32" # TODO: 내 IP를 변수로 처리할 수 있을까?
}

# NAT 인바운드 - WAS의 모든 트래픽 허용
resource "aws_vpc_security_group_ingress_rule" "allow_all_from_was" {
  description       = "Allow traffic from WAS"
  security_group_id = aws_security_group.nat_sg.id

  from_port                    = 0
  to_port                      = 0
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.was_sg.id
}

# NAT 아웃바운드
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_nat" {
  security_group_id = aws_security_group.nat_sg.id

  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# WAS 보안 그룹
resource "aws_security_group" "was_sg" {
  name   = "was-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "WAS-SG"
  }
}

# WAS 인바운드 - 8000 포트로 들어오는 ALB 트래픽 허용
resource "aws_vpc_security_group_ingress_rule" "allow_8000" {
  description       = "Allow traffic from 8000 port"
  security_group_id = aws_security_group.was_sg.id

  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb_sg.id
}

# WAS 인바운드 - 22 포트로 들어오는 NAT 트래픽 허용
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_nat" {
  description       = "Allow SSH traffic from NAT Instance"
  security_group_id = aws_security_group.was_sg.id

  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.nat_sg.id
}

# WAS 아웃바운드
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_was" {
  security_group_id = aws_security_group.was_sg.id

  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# ALB 보안 그룹
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ALB-SG"
  }
}

# ALB 인바운드 - 80(HTTP) 포트로 들어오는 모든 트래픽 허용
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  description       = "Allow 80 traffic"
  security_group_id = aws_security_group.alb_sg.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

# ALB 인바운드 - 443(HTTPS) 포트로 들어오는 모든 트래픽 허용
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  description       = "Allow 443 traffic"
  security_group_id = aws_security_group.alb_sg.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

# ALB 아웃바운드
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_alb" {
  security_group_id = aws_security_group.alb_sg.id

  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# RDS 보안 그룹
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "RDS-SG"
  }
}

# RDS 인바운드 - WAS의 3306으로 들어오는 트래픽 허용
resource "aws_vpc_security_group_ingress_rule" "allow_3306_from_was" {
  description       = "Allow 3306 traffic from WAS"
  security_group_id = aws_security_group.rds_sg.id

  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.was_sg.id
}

# RDS 아웃바운드
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_rds" {
  security_group_id = aws_security_group.rds_sg.id

  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}
