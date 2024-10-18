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
  cidr_block = "10.123.1.0/24"
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


resource "aws_security_group" "asa_sg" {
    vpc_id = aws_vpc.asa_vpc.id
    name = "asa_sg"
    description = "Allow inbound traffic on port 22"

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

      tags = {
        Name = "asa_sg"
        Stage = "dev"
    }
}

resource "aws_key_pair" "asa_auth" {
  key_name   = "asakey"
  public_key = file("~/.ssh/asakey.pub")
}


resource "aws_instance" "dev_node" {
  ami = data.aws_ami.server_ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.asa_auth.key_name
  security_groups = [aws_security_group.asa_sg.name]
  subnet_id = aws_subnet.asa_public_subnet.id

  root_block_device {
    volume_size = 8
  }
  tags = {
    Name = "dev_node"
    Stage = "dev"
  }

}
