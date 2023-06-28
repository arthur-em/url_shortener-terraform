
# Create RDS Instance and assign it to a subnet group

resource "aws_db_subnet_group" "clg_db_sng" {
  name = "main"

  subnet_ids = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id
  ]

  tags = {
    Name = "clg_db_subnetgroup"
  }
}

# Create RDS Instance 
resource "aws_db_instance" "clg_db" {
  allocated_storage      = 20
  db_name                = "wordpress"
  engine                 = "mysql"
  engine_version         = "8.0.28"
  instance_class         = "db.t3.micro"
  multi_az               = false
  username               = "admin"
  password               = "01020304"
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.clg_db_sng.name
  identifier             = "clg-wordpress-db2"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}
