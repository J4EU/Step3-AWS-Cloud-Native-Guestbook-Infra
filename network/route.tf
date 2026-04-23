# 퍼블릭 서브넷 라우팅 테이블
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route { # 인터넷 게이트웨이(igw)와 연결
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# 퍼블릭 서브넷 (AZ-a) 라우팅 테이블 연결
resource "aws_route_table_association" "public_rt_assoc1" {
  subnet_id      = aws_subnet.public_subnet1_a.id
  route_table_id = aws_route_table.public_rt.id
}

# 퍼블릭 서브넷 (AZ-c) 라우팅 테이블 연결
resource "aws_route_table_association" "public_rt_assoc2" {
  subnet_id      = aws_subnet.public_subnet1_c.id
  route_table_id = aws_route_table.public_rt.id
}

# 프라이빗 서브넷 (AZ-a) 라우팅 테이블
resource "aws_route_table" "private_a_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-a-rt"
  }
}

# 프라이빗 서브넷 (AZ-a) 라우팅 테이블 연결
resource "aws_route_table_association" "private_rt_assoc1" {
  subnet_id      = aws_subnet.private_subnet1_a.id
  route_table_id = aws_route_table.private_a_rt.id
}

# 프라이빗 서브넷 (AZ-c) 라우팅 테이블
resource "aws_route_table" "private_c_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-c-rt"
  }
}

# 프라이빗 서브넷 (AZ-c) 라우팅 테이블 연결
resource "aws_route_table_association" "private_rt_assoc2" {
  subnet_id      = aws_subnet.private_subnet1_c.id
  route_table_id = aws_route_table.private_c_rt.id
}

# 프라이빗 서브넷 (RDS) 라우팅 테이블
resource "aws_route_table" "private_rds_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-rds-rt"
  }
}

# 프라이빗 서브넷 (RDS) 라우팅 테이블 연결
resource "aws_route_table_association" "private_rds_rt_assoc1" {
  subnet_id      = aws_subnet.private_subnet2_a.id
  route_table_id = aws_route_table.private_rds_rt.id
}

# 프라이빗 서브넷 (RDS) 라우팅 테이블 연결
resource "aws_route_table_association" "private_rds_rt_assoc2" {
  subnet_id      = aws_subnet.private_subnet2_c.id
  route_table_id = aws_route_table.private_rds_rt.id
}

# nat_instance_a.tf에 정의
# 프라이빗 서브넷(AZ-a-1) 라우팅 테이블 - 라우팅 규칙 (NAT 인스턴스의 ENI로 전송)

# nat_instance_c.tf에 정의
# 프라이빗 서브넷(AZ-c-1) 라우팅 테이블 - 라우팅 규칙 (NAT 인스턴스의 ENI로 전송)
