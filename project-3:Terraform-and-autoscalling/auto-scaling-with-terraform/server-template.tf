resource "aws_launch_template" "example" {
  name          = "my-launch-template"
  image_id       = "ami-0522ab6e1ddcc7055"
  instance_type  = "t2.micro"
  network_interfaces {

  security_groups = [aws_security_group.example.id]
  }

  tags = {
    Name = "web-server-Django"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}
