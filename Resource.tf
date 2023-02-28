resource "aws_vpc" "prime-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "prime-vpc"
  }
}#vpc subnets pub1
resource "aws_subnet" "prime-pub1" {
  vpc_id     = aws_vpc.prime-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pub1"
  }
}
#vpc subnets private1
resource "aws_subnet" "prime-priv1" {
  vpc_id     = aws_vpc.prime-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "priv1"
  }
}
#vpc subnet private2
resource "aws_subnet" "prime-priv2" {
  vpc_id     = aws_vpc.prime-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "priv2"
  }
}
# igw creation
resource "aws_internet_gateway" "prime-igw" {
  vpc_id = aws_vpc.prime-vpc.id

  tags = {
    Name = "prime-igw"
  }
}
#route table public
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.prime-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prime-igw.id
  }

tags = {
    Name = "public-rt"
  }
}
#route table private
resource "aws_route_table" "priv-rt" {
  vpc_id = aws_vpc.prime-vpc.id

  route = []

  tags = {
    Name = "private-rt"
  }
}
# Route table association public
resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.prime-vpc.id
  route_table_id = aws_route_table.public-rt.id
}
# private route table association
resource "aws_main_route_table_association" "b" {
  vpc_id         = aws_vpc.prime-vpc.id
  route_table_id = aws_route_table.priv-rt.id
}