resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc1" {
  subnet_id      = aws_subnet.public_subnet1_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc2" {
  subnet_id      = aws_subnet.public_subnet1_c.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_was1_rt" {
  vpc_id = aws_vpc.vpc.id

  # TODO
  # route {NAT 인스턴스(AZ-a_로 라우팅}

  tags = {
    Name = "private-WAS1-rt"
  }
}

resource "aws_route_table" "private_was2_rt" {
  vpc_id = aws_vpc.vpc.id

  # TODO
  # route {NAT 인스턴스(AZ-c)로 라우팅}

  tags = {
    Name = "private-WAS2-rt"
  }
}

resource "aws_route_table" "private_rds_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-RDS-rt"
  }
}

resource "aws_route_table_association" "private_rds_rt_assoc1" {
  subnet_id      = aws_subnet.private_subnet2_a.id
  route_table_id = aws_route_table.private_rds_rt.id
}

resource "aws_route_table_association" "private_rds_rt_assoc2" {
  subnet_id      = aws_subnet.private_subnet2_c.id
  route_table_id = aws_route_table.private_rds_rt.id
}
