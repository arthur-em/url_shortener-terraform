# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create custom vpc

resource "aws_vpc" "main" {
  cidr_block = "10.16.0.0/16"

  # you need to enable dnshostnames otherwise you'll have issues mounting EFS later on!!
  enable_dns_hostnames = true

  tags = {
    Name = "clg-vpc"
  }
}

# Create subnets
# Availability Zone A
resource "aws_subnet" "alb_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "clg-sn-alb-A"
  }
}


resource "aws_subnet" "app_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "clg-sn-app-A"
  }
}


resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "clg-sn-db-A"
  }
}


# Availability Zone B
resource "aws_subnet" "alb_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "clg-sn-alb-B"
  }
}


resource "aws_subnet" "app_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "clg-sn-app-B"
  }
}


resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.5.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "clg-sn-db-B"
  }
}


# Create Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "clg-igw"
  }
}

# Create Route-table 

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "clg-rt"
  }
}

# Associate Route tables with alb subnets
resource "aws_route_table_association" "rtsna_a" {
  subnet_id      = aws_subnet.alb_a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rtsna_b" {
  subnet_id      = aws_subnet.alb_b.id
  route_table_id = aws_route_table.rt.id
}


# Keypair
resource "aws_key_pair" "tf_kp" {
  key_name   = "terraform_keys"
  public_key = file("~/.ssh/tf_keypair.pub")
}

