resource "aws_autoscaling_group" "example" {
    
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"  # Optionally specify the version
  }
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = [data.aws_subnet.sub-id.id]

  tag {
      key                 = "Name"
      value               = "MyAutoScalingGroup"
      propagate_at_launch = true
    }
  depends_on =[
    aws_launch_template.example,
  ]
}
