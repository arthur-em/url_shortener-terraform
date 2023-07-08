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
    Name = "clg-sg-alb"
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
