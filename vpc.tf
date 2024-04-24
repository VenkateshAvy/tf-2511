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
resource "aws_route_table_association" "ibm-web-rtb-asscn" {
  subnet_id      = aws_subnet.ibm-web-subnet.id
  route_table_id = aws_route_table.ibm-web-rtb.id
}
resource "aws_route_table_association" "ibm-db-rtb-asscn" {
  subnet_id      = aws_subnet.ibm-db-subnet.id
  route_table_id = aws_route_table.ibm-db-rtb.id
}
#web nacl
resource "aws_network_acl" "ibm-web-nacl" {
  vpc_id = aws_vpc.ibm-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ibm-web-nacl"
  }
}
#db-nacl
resource "aws_network_acl" "ibm-db-nacl" {
  vpc_id = aws_vpc.ibm-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ibm-db-nacl"
  }
}