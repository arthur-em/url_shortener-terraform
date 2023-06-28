resource "aws_instance" "app2" {
  ami                         = "ami-09f49599bf0b0b4f6"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.alb_a.id
  key_name                    = "terraform_keys"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  # user_data = "${file("init.sh")}"

  tags = {
    Name = "tf_clg_instanceB"
  }

}
