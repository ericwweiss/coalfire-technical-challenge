terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.65.0"
    }
  }

  required_version = ">= 1.9.5"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

#-------------VPC-----------------------

resource "aws_vpc" "main" {
  cidr_block    = var.vpc_cidr

  tags = {
    Name        = "Main VPC"
    Environment = var.environment
    }
}

#-------------IGW-----------------------

resource "aws_internet_gateway" "igw" {
  vpc_id        = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

#-------------Elastic IP-----------------------

resource "aws_eip" "nat_eip" {
  count      = length(var.azs)
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name     = "EIP--${count.index+1}"
  }
}

#-------------Public Subnets-----------------------

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.azs)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "Sub-${count.index+1}"
    Environment = var.environment
  }
}

#-------------Private Subnets-----------------------

resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.azs)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "Sub-${count.index+3}"
    Environment = var.environment
  }
}

#-------------NAT Gateways-----------------------

resource "aws_nat_gateway" "nat_gateways" {
  count         = length(var.azs)      
  allocation_id = element(aws_eip.nat_eip.*.id , count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id , count.index)
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name        = "NAT-GW--${count.index+1}"
    Environment = var.environment
  }
}

#-------------Route Table for Public Subnets-----------------------

resource "aws_route_table" "public_rt" {
  vpc_id        = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = var.environment
  }
}

#-------------Route Table for Private Subnets-----------------------

resource "aws_route_table" "private_rt" {
  vpc_id        = "${aws_vpc.main.id}"
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = var.environment
  }
}

#-------------Routes for Connectivity Testing-----------------------

resource "aws_route" "public_igw" {
  route_table_id         = "${aws_route_table.public_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

#resource "aws_route" "private_nat_gateway" {
#  count                  = length(var.private_subnets)
#  route_table_id         = "${aws_route_table.private_rt.id}"
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id         = "${aws_nat_gateway.nat_gateways.1.id}"
#}

#-------------Route Table Associations-----------------------

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = aws_route_table.private_rt.id
}


#-------------Default SG-----------------------

resource "aws_security_group" "main_default" {
  name        = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.main.id}"
  depends_on  = [aws_vpc.main]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
    }
  
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
    }

  tags = {
    Environment = var.environment
  }
}
