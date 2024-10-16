resource "aws_vpc" "asa_vpc" {
  cidr_block = "10.123.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
    Name = "asa_vpc"
    Stage = "dev"
    }
}


resource "aws_subnet" "asa_public_subnet" {
  vpc_id = aws_vpc.asa_vpc.id
  cidr_block = "10.123.1.0/16"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
    Name = "asa_public_subnet"
    Stage = "dev"
    }
}

resource "aws_internet_gateway" "asa_internet_gateway" {
  vpc_id = aws_vpc.asa_vpc.id
    tags = {
    Name = "asa_internet_gateway"
    Stage = "dev"
    }
}

resource "aws_route_table" "asa_public_rt" {
  vpc_id = aws_vpc.asa_vpc.id

  tags = {
    Name = "asa_route_table"
    Stage = "dev"
    }
}

resource "aws_route" "default_route" {
  route_table_id = aws_route_table.asa_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.asa_internet_gateway.id
}

resource "aws_route_table_association" "asa_public_subnet_association" {
  subnet_id = aws_subnet.asa_public_subnet.id
  route_table_id = aws_route_table.asa_public_rt.id
}
