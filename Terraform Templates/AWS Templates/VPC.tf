# VPC with one private subnet and other public subnet

# VPC
resource "aws_vpc" "VPC_terraform" {
  cidr_block = "10.0.0.0/16"

  tags = {
    CreatedBy = "Ibrahim"
    Platform  = "Terraform"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.VPC_terraform.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "Public Subnet"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.VPC_terraform.id
  availability_zone = "us-east-1c"
  cidr_block        = "10.0.3.0/24"

  tags = {
    Name = "Public Subnet2"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.VPC_terraform.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "private Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.VPC_terraform.id

  tags = {
    Name = "main"
  }
}

# Nat Gatway
resource "aws_nat_gateway" "NAT_GW_PrivateSubnet" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# Assigning Elastic IP for the Nat Gateway
resource "aws_eip" "nat" {
  depends_on = [
    aws_internet_gateway.gw
  ]
}

# Route Table for the Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.VPC_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Public subnet attached with Internet Gateway"
  }
}

# Associate Public subnet with route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Route Table for the Private Subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.VPC_terraform.id

  route {
    cidr_block = "10.0.2.0/24"
    nat_gateway_id = aws_nat_gateway.NAT_GW_PrivateSubnet.id
  }
  tags = {
    Name = "Nat Gateway subnet attached with Private Subnet"
  }
}

# Associate Private subnet with route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Network ACL
resource "aws_network_acl" "main" {
  vpc_id     = aws_vpc.VPC_terraform.id
  subnet_ids = [aws_subnet.public_subnet.id]
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  egress {
    rule_no    = 103
    action     = "allow"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }


  tags = {
    Name = "Public NACL"
  }
}
