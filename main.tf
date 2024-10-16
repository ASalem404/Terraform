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
