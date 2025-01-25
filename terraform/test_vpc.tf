terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1" # Update with your desired region
}

resource "aws_vpc" "vpc1" {
  cidr_block           = "192.168.1.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC1"
  }
}

resource "aws_internet_gateway" "igw_vpc1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "InternetGatewayVPC1"
  }
}

resource "aws_subnet" "private_subnet_vpc1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnetVPC1"
  }
}

resource "aws_subnet" "public_subnet_vpc1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "192.168.3.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnetVPC1"
  }
}

resource "aws_route_table" "public_rt_vpc1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "PublicRouteTableVPC1"
  }
}

resource "aws_route" "public_route_vpc1" {
  route_table_id         = aws_route_table.public_rt_vpc1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_vpc1.id
}

resource "aws_route_table_association" "rt_assoc_vpc1" {
  subnet_id      = aws_subnet.public_subnet_vpc1.id
  route_table_id = aws_route_table.public_rt_vpc1.id
}

resource "aws_vpc" "vpc2" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC2"
  }
}

resource "aws_internet_gateway" "igw_vpc2" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "InternetGatewayVPC2"
  }
}

resource "aws_subnet" "private_subnet_vpc2" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnetVPC2"
  }
}

resource "aws_subnet" "public_subnet_vpc2" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnetVPC2"
  }
}

resource "aws_route_table" "public_rt_vpc2" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "PublicRouteTableVPC2"
  }
}

resource "aws_route" "public_route_vpc2" {
  route_table_id         = aws_route_table.public_rt_vpc2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_vpc2.id
}

resource "aws_route_table_association" "rt_assoc_vpc2" {
  subnet_id      = aws_subnet.public_subnet_vpc2.id
  route_table_id = aws_route_table.public_rt_vpc2.id
}

data "aws_availability_zones" "available" {}

output "vpc1_id" {
  value = aws_vpc.vpc1.id
}

output "private_subnet_id_vpc1" {
  value = aws_subnet.private_subnet_vpc1.id
}

output "public_subnet_id_vpc1" {
  value = aws_subnet.public_subnet_vpc1.id
}

output "vpc2_id" {
  value = aws_vpc.vpc2.id
}

output "private_subnet_id_vpc2" {
  value = aws_subnet.private_subnet_vpc2.id
}

output "public_subnet_id_vpc2" {
  value = aws_subnet.public_subnet_vpc2.id
}
