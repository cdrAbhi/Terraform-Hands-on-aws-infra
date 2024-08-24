#Vpc Block
resource "aws_vpc" "custom-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-${var.my-env}"
  }
}

#Subnet Block
resource "aws_subnet" "custom-sub" {
  count             = 2 # Create two subnets in different AZs
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)
  vpc_id            = aws_vpc.custom-vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  tags = {
    Name = "${var.my-env}-subnet-${count.index}"
  }

  depends_on = [
    aws_vpc.custom-vpc
  ]

}