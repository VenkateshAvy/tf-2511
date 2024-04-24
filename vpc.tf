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
resource "aws_network_acl_association" "ibm-nacl-web-asscn" {
  network_acl_id = aws_network_acl.ibm-web-nacl.id
  subnet_id      = aws_subnet.ibm-web-subnet.id
}
resource "aws_network_acl_association" "ibm-nacl-db-asscn" {
  network_acl_id = aws_network_acl.ibm-db-nacl.id
  subnet_id      = aws_subnet.ibm-db-subnet.id
}
#ibm sg
resource "aws_security_group" "ibm-web-sg" {
  name        = "ibm-web-sg"
  description = "Allow SSH&HTTP  traffic"
  vpc_id      = aws_vpc.ibm-vpc.id

  tags = {
    Name = "ibm-web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
  security_group_id = aws_security_group.ibm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow-http" {
  security_group_id = aws_security_group.ibm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ibm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
#ibm db sg
resource "aws_security_group" "ibm-db-sg" {
  name        = "ibm-web-sg"
  description = "Allow SSH&postgres traffic"
  vpc_id      = aws_vpc.ibm-vpc.id

  tags = {
    Name = "ibm-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh-db" {
  security_group_id = aws_security_group.ibm-db-sg.id
  cidr_ipv4         = "10.0.0.0/20"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow-postgres-db" {
  security_group_id = aws_security_group.ibm-db-sg.id
  cidr_ipv4         = "10.0.0.0/20"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_db" {
  security_group_id = aws_security_group.ibm-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
