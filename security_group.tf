# Create Security Group for application load balancer
resource "aws_security_group" "alb_sg" {
  name        = "clg_alb_sg"
  description = "Allow HTTP/S and SSH traffic via Terraform"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all http traffic from any source"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all https traffic from any source"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all traffic to flow out"
  }

  tags = {
    Name = "clg-sg-app"
  }
}

# Create Security Group for ec2 TEST instance
resource "aws_security_group" "test_sg" {
  name        = "clg_test_sg"
  description = "Allow HTTP/S and SSH traffic via Terraform"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all http traffic from any source"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all https traffic from any source"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["109.175.252.150/32"]
    description = "allow all ssh traffic from my ip address"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all traffic to flow out"
  }

  tags = {
    Name = "clg-sg-test"
  }
}

# Create security group for EC2 Instances
resource "aws_security_group" "app_sg" {
  name        = "clg_app_sg"
  description = "Allow HTTP/S traffic from the load balancer; allow SSH traffic from my IP address only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "allow all http traffic from application load balancer only"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "allow all https traffic from application load balancer only "
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["109.175.252.150/32"]
    description = "allow ssh traffic from IP address only"

  }

  # ingress {
  #   from_port   = 2049
  #   to_port     = 2049
  #   protocol    = "tcp"
  #   self        = true
  #   description = "allow NFS (file system) traffic from instances with this security group"
  # }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all traffic to flow out"
  }

  tags = {
    Name = "clg-sg-app"
  }
}

# Create Security Group for Elastic File System Mounts
resource "aws_security_group" "efs_sg" {
  name        = "clg_efs_sg"
  description = "Allow NFS/EFS traffic from EC2 Instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id, aws_security_group.test_sg.id]
    description     = "allow all NFS traffic from EC2 Instances"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all traffic to flow out"
  }

  tags = {
    Name = "clg-sg-efs"
  }
}

# Create RDS Security group

resource "aws_security_group" "rds_sg" {
  name        = "clg_rds_sg"
  description = "Allow RDS traffic from EC2 only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id, aws_security_group.test_sg.id]
    description     = "allow all mysql traffic from any instance with the above security group attached"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all traffic to flow out"
  }

  tags = {
    Name = "clg-sg-rds"
  }
}
