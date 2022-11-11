provider "aws" {
  region  = "us-east-1"
}

resource "aws_vpc" "VPC" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}



resource "aws_subnet" "PublicSubnet1" {
  cidr_block = var.pub_cidr
  vpc_id = aws_vpc.VPC.id
  availability_zone = var.pub_az
}



resource "aws_subnet" "PrivateSubnet1" {
  cidr_block = var.pri_cidr
  vpc_id = aws_vpc.VPC.id
  availability_zone = var.pri_az
}

resource "aws_route_table" "RouteTablePublic" {
  vpc_id = aws_vpc.VPC.id
  depends_on = [ aws_internet_gateway.Igw ]

  tags = {
    Name = "Public Route Table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw.id
  }
}

resource "aws_route_table_association" "AssociationForRouteTablePublic0" {
  subnet_id = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.RouteTablePublic.id
}



resource "aws_route_table" "RouteTablePrivate1" {
  vpc_id = aws_vpc.VPC.id
  depends_on = [ aws_nat_gateway.NatGw1 ]

  tags = {
    Name = "Private Route Table A"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NatGw1.id
  }
}

resource "aws_route_table_association" "AssociationForRouteTablePrivate10" {
  subnet_id = aws_subnet.PrivateSubnet1.id
  route_table_id = aws_route_table.RouteTablePrivate1.id
}



resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.VPC.id
}

resource "aws_eip" "EipForNatGw1" {
}

resource "aws_nat_gateway" "NatGw1" {
  allocation_id = aws_eip.EipForNatGw1.id
  subnet_id = aws_subnet.PublicSubnet1.id

  tags = {
    Name = "NAT GW A"
  }
}

resource "aws_security_group" "SecurityGroup1" {
  name = "allow-ssh-traffic"
  description = "A security group that allows inbound SSH traffic (TCP port 22)."
  vpc_id = aws_vpc.VPC.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [""]
    description = "Allow SSH traffic"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "SecurityGroup2" {
  name = "allow-web-traffic"
  description = "A security group that allows inbound web traffic (TCP ports 80 and 443)."
  vpc_id = aws_vpc.VPC.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [""]
    description = "Allow HTTP traffic"
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [""]
    description = "Allow HTTPS traffic"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "SecurityGroup3" {
  name = "custom-sg"
  description = "Build a custom security group."
  vpc_id = aws_vpc.VPC.id



}