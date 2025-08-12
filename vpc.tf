resource "aws_vpc" "eks-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = var.tags

}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
additional_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
}
}

resource "aws_internet_gateway" "eks-gw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = var.tags
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-gw.id
  }

  tags = var.tags
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks-ngw.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public-rta1" {
  subnet_id      = aws_subnet.public_subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-rta2" {
  subnet_id      = aws_subnet.public_subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-rta1" {
  subnet_id      = aws_subnet.private_subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-rta2" {
  subnet_id      = aws_subnet.private_subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_nat_gateway" "eks-ngw" {
  allocation_id = aws_eip.eks-ngw-eip.id
  subnet_id     = aws_subnet.public_subnet-1.id

  tags = var.tags

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.eks-gw]
}

resource "aws_eip" "eks-ngw-eip" {
  domain = "vpc"
  tags = var.tags
  depends_on                = [aws_internet_gateway.eks-gw]
}

resource "aws_subnet" "public_subnet-1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 1)
  tags = var.tags
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "public_subnet-2" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 2)
  tags = var.tags
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_subnet" "private_subnet-1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 3)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge( var.tags, local.additional_tags)
}

resource "aws_subnet" "private_subnet-2" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 4)
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = merge( var.tags, local.additional_tags)
}
