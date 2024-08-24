# ALB
resource "aws_lb" "my_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.custom-sg.id]
  subnets            = aws_subnet.custom-sub[*].id

  enable_deletion_protection = var.alb_enable_deletion_protection
  enable_http2               = var.alb_enable_http2
  idle_timeout               = var.alb_idle_timeout
  drop_invalid_header_fields = var.alb_drop_invalid_header_fields

  tags = {
    Name = "${var.my-env}-MyALB"
  }

  # Uncomment the following if you want to enable access logs
  # access_logs { 
  #   bucket = aws_s3_bucket.alb_logs.bucket
  #   prefix  = var.alb_access_logs_prefix
  #   enabled = true
  # }

  # Uncomment the following if you want to add a dependency on the S3 bucket
  # depends_on = [
  #   aws_s3_bucket.alb_logs
  # ]
}

# Target Group
resource "aws_lb_target_group" "my_target_group" {
  name     = "${var.my-env}-target-group"
  port     = var.alb_target_group_port
  protocol = var.alb_target_group_protocol
  vpc_id   = aws_vpc.custom-vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.my-env}-target-group"
  }

  depends_on = [
    aws_lb.my_alb
  ]
}

# Target Group Attachment
resource "aws_lb_target_group_attachment" "my_instance_attachment" {
  for_each = { for idx, inst in aws_instance.inst : idx => inst.id }

  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = each.value
  port             = var.alb_target_group_port

  depends_on = [
    aws_instance.inst,
    aws_lb_target_group.my_target_group
  ]
}

# ALB Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    # type             = "fixed-response"
    # fixed_response {
    #   content_type = "text/plain"
    #   message_body = "Welcome to the ALB!"
    #   status_code  = "200"
    # }
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }

  depends_on = [
    aws_lb.my_alb
  ]
}

# ALB Listener Rule
resource "aws_lb_listener_rule" "default_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }

  condition {
    host_header {
      values = ["example.com"]
    }
  }

  depends_on = [
    aws_lb_listener.http_listener
  ]
}
