## Resource-1: Create VPC for Soley IMS in AWS
resource "aws_vpc" "soley" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "soley"
  }
}

# Resource-2: Create Public Subnet 1
resource "aws_subnet" "soley-public-subnet-1" {
  vpc_id                  = aws_vpc.soley.id
  cidr_block              = var.public_subnet1_cidr_block
  availability_zone       = var.availability_zone1
  map_public_ip_on_launch = true

  tags = {
    Name = "soley-public-subnet-1"
  }
}

# Resource-3: Create Public Subnet 2
resource "aws_subnet" "soley-public-subnet-2" {
  vpc_id                  = aws_vpc.soley.id
  cidr_block              = var.public_subnet2_cidr_block
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name = "soley-public-subnet-2"
  }
}

# Resource-4: Internet Gateway for public subnets
resource "aws_internet_gateway" "soley-igw" {
  vpc_id = aws_vpc.soley.id

  tags = {
    Name = "soley-internet-gateway"
  }
}

# Resource-5: Create Route Table for public subnets
resource "aws_route_table" "soley-public-route-table" {
  vpc_id = aws_vpc.soley.id

  tags = {
    Name = "soley-public-route-table"
  }
}
# Resource-6: Create Route in Route Table for Internet Access for public subnets
resource "aws_route" "soley-public-route" {
  route_table_id         = aws_route_table.soley-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.soley-igw.id
}

# Resource-7: Associate the Route Table with the Public Subnet 1
resource "aws_route_table_association" "soley-public-route-table-associate-1" {
  route_table_id = aws_route_table.soley-public-route-table.id
  subnet_id      = aws_subnet.soley-public-subnet-1.id
}

# Resource-8: Associate the Route Table with the Public Subnet 2
resource "aws_route_table_association" "soley-public-route-table-associate-2" {
  route_table_id = aws_route_table.soley-public-route-table.id
  subnet_id      = aws_subnet.soley-public-subnet-2.id
}

# Resource-9: Create Private Subnet 1
resource "aws_subnet" "soley-private-subnet-1" {
  vpc_id            = aws_vpc.soley.id
  cidr_block        = var.private_subnet1_cidr_block
  availability_zone = var.availability_zone1

  tags = {
    Name = "soley-private-subnet-1"
  }
}
# Resource-10: Create Private Subnet 2
resource "aws_subnet" "soley-private-subnet-2" {
  vpc_id            = aws_vpc.soley.id
  cidr_block        = var.private_subnet2_cidr_block
  availability_zone = var.availability_zone2

  tags = {
    Name = "soley-private-subnet-2"
  }
}

# Resource-11: Create Route Table for private subnets
resource "aws_route_table" "soley-private-route-table" {
  vpc_id = aws_vpc.soley.id

  tags = {
    Name = "soley-private-route-table"
  }
}


# Resource-12: Associate the Route Table with the Private Subnet 1
resource "aws_route_table_association" "soley-private-route-table-associate-1" {
  route_table_id = aws_route_table.soley-private-route-table.id
  subnet_id      = aws_subnet.soley-private-subnet-1.id
}

# Resource-13: Associate the Route Table with the Private Subnet 2
resource "aws_route_table_association" "soley-private-route-table-associate-2" {
  route_table_id = aws_route_table.soley-private-route-table.id
  subnet_id      = aws_subnet.soley-private-subnet-2.id
}


# Resource-14: Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "soley-nat-eip"
  }
}


# Resource-15: Create a NAT Gateway in Public Subnet 1
resource "aws_nat_gateway" "soley_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.soley-public-subnet-1.id

  tags = {
    Name = "soley-nat-gateway"
  }
}

# Resource-16: Add a route in the private route table to route traffic through the NAT Gateway
resource "aws_route" "soley-private-nat-route" {
  route_table_id         = aws_route_table.soley-private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.soley_nat_gw.id
}

