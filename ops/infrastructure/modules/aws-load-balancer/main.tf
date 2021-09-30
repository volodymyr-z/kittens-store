resource "aws_lb" "load_balancer_test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = concat([aws_security_group.load_balancer_sg.id], var.security_group_ids)
  subnets            = var.vpc.subnet_ids

  enable_deletion_protection = false

  tags = {
    Environment = "global"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.load_balancer_test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_test.arn
  }
}

resource "aws_lb_target_group" "target_group_test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc.vpc_id

  health_check {
    enabled = true
    path = "/kittens/info"
    interval = 5
    timeout = 2
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment_test" {
  count = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.target_group_test.arn
  target_id        = element(var.instance_ids, count.index)
  port             = 80
}

resource "aws_security_group" "load_balancer_sg" {
  name_prefix      = "load-balancer-sg"
  description = "Security group for Load balancer"
  vpc_id      = var.vpc.vpc_id

  ingress {
    description      = "HTTP from outside world"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "load-balancer-sg"
  }
}
