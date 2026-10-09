resource "aws_vpc" "devops_vpc" {
  cidr_block       = "11.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "devops_project_vpc"
  }
}

resource "aws_subnet" "public_sub_1" {
  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = "11.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public_Subnet_1"
  }
}

resource "aws_subnet" "public_sub_2" {
  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = "11.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public_Subnet_2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "devops_vpc_gw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "devops_vpc_rt"
  }
}

resource "aws_route_table_association" "rt_sub1" {
  subnet_id      = aws_subnet.public_sub_1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rt_sub2" {
  subnet_id      = aws_subnet.public_sub_2.id
  route_table_id = aws_route_table.rt.id
}



