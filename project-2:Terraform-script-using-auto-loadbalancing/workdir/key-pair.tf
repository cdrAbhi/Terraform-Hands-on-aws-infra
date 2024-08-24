#aws_key_pair Block
resource "aws_key_pair" "key" {
  key_name   = "test-${var.my-env}"
  public_key = file("${path.module}/mykey.pub")
}