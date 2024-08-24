# Internet Gateway Block
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom-vpc.id

  tags = {
    Name = "${var.my-env}-igw"
  }
}

# Route Table Block
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.my-env}-public-route-table"
  }
}


# Route Table Association
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.custom-sub.*.id, count.index)
  route_table_id = aws_route_table.public.id
}