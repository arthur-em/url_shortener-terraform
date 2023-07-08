# create application load balancer
# terraform aws create application load balancer
resource "aws_lb" "alb" {
  name               = "clg-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnet_mapping {
    subnet_id = aws_subnet.alb_a.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.alb_b.id
  }

  enable_deletion_protection = false

  tags = {
    Name = "clg_alb"
  }
}

# create target group
# terraform aws create target group
resource "aws_lb_target_group" "alb_tg" {
  name        = "clg-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301,302"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# create a listener on port 80 with redirect action
# terraform aws create listener
resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# create a listener on port 443 with forward action
# terraform aws create listener
resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:114457763702:certificate/fb347bc0-bc0e-4000-bb69-dc2d45c92a98"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

