resource "aws_vpc" "asa_vpc" {
  cidr_block = "10.123.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
    Name = "asa_vpc"
    Stage = "dev"
    }
}

