resource "aws_db_subnet_group" "db_sn_group" {
  name       = "rds-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet2_a.id, aws_subnet.private_subnet2_c.id]

  tags = {
    Name = "DB Subnet Group"
  }
}

resource "aws_db_parameter_group" "db_pg" {
  name   = "rds-pg"
  family = "mariadb11.8"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage = 20
  engine            = "mariadb"
  engine_version    = "11.8"
  instance_class    = "db.t3.micro"

  db_name  = "guestbook"
  username = "admin"
  password = var.rds_password

  db_subnet_group_name = aws_db_subnet_group.db_sn_group.name
  parameter_group_name = aws_db_parameter_group.db_pg.name

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true
  multi_az            = true
}

output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}
