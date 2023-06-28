
# create a launch template
# terraform aws launch template
resource "aws_launch_template" "app_lt" {
  name          = "clg-launch-template"
  image_id      = "ami-04c7a11ae33d06677"
  instance_type = "t2.micro"
  key_name      = "terraform_keys"
  description   = "Launch template for asg"

  monitoring {
    enabled = false
  }

  vpc_security_group_ids = [aws_security_group.app_sg.id]
}

# create auto scaling group
# terraform aws autoscaling group
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.app_a.id, aws_subnet.app_b.id]
  desired_capacity    = 0
  max_size            = 0
  min_size            = 0
  name                = "clg-asg"
  health_check_type   = "ELB"

  launch_template {
    name    = aws_launch_template.app_lt.name
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-app"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [target_group_arns]
  }
}

# attach auto scaling group to alb target group
# terraform aws autoscaling attachment
resource "aws_autoscaling_attachment" "asg_alb_target_group_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.alb_tg.id
}


