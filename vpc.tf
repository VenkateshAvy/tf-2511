resource "aws_vpc" "ibm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ibm-vpc"
  }
}
resource "aws_subnet" "ibm-web-subnet" {
  vpc_id     = aws_vpc.ibm-vpc.id
  cidr_block = "10.0.0.0/20"

  tags = {
    Name = "ibm-web-subnet"
  }
}
resource "aws_subnet" "ibm-db-subnet" {
  vpc_id     = aws_vpc.ibm-vpc.id
  cidr_block = "10.0.16.0/20"

  tags = {
    Name = "ibm-db-subnet"
  }
}
resource "aws_internet_gateway" "ibm-igw" {
  vpc_id = aws_vpc.ibm-vpc.id

  tags = {
    Name = "ibm-igw"
  }
}
resource "aws_route_table" "ibm-web-rtb" {
  vpc_id = aws_vpc.ibm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ibm-igw.id
  }

  tags = {
    Name = "ibm-web-rtb"
  }
}
resource "aws_route_table" "ibm-db-rtb" {
  vpc_id = aws_vpc.ibm-vpc.id

  tags = {
    Name = "ibm-db-rtb"
  }
}