# VPC 구간
resource "aws_vpc" "terra-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "terra-vpc"
  }
}

# Subnet 구간
resource "aws_subnet" "terra-sub-public1" {
  vpc_id                  = aws_vpc.terra-vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "terra-sub-public1"
  }
}

resource "aws_subnet" "terra-sub-public2" {
  vpc_id                  = aws_vpc.terra-vpc.id
  cidr_block              = "10.0.20.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "terra-sub-public2"
  }
}

resource "aws_subnet" "terra-sub-private1" {
  vpc_id            = aws_vpc.terra-vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "terra-sub-private1"
  }
}

resource "aws_subnet" "terra-sub-private2" {
  vpc_id            = aws_vpc.terra-vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "terra-sub-private2"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "terra-igw" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "terra-igw"
  }
}

resource "aws_eip" "nat" {
  vpc      = true
}

# NAT 게이트웨이 생성
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.terra-sub-public1.id

  tags = {
    Name = "terra-NAT"
  }
}

# 라우팅 테이블 생성
resource "aws_route_table" "terra-public1" {
  vpc_id = aws_vpc.terra-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }
  tags = {
    Name = "terra-public1"
  }
}

resource "aws_route_table_association" "terra-routing-public1" {
  subnet_id      = aws_subnet.terra-sub-public1.id
  route_table_id = aws_route_table.terra-public1.id
}

resource "aws_route_table" "terra-public2" {
  vpc_id = aws_vpc.terra-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }
  tags = {
    Name = "terra-public2"
  }
}

resource "aws_route_table_association" "terra-routing-public2" {
  subnet_id      = aws_subnet.terra-sub-public2.id
  route_table_id = aws_route_table.terra-public2.id
}


# Private 라우팅 테이블 생성

resource "aws_route_table" "terra-private1" {
  vpc_id = aws_vpc.terra-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "terra-private1"
  }
}

resource "aws_route_table_association" "terra-routing-private1" {
  subnet_id      = aws_subnet.terra-sub-private1.id
  route_table_id = aws_route_table.terra-private1.id
}

resource "aws_route_table" "terra-private2" {
  vpc_id = aws_vpc.terra-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "terra-private2"
  }
}

resource "aws_route_table_association" "terra-routing-private2" {
  subnet_id      = aws_subnet.terra-sub-private2.id
  route_table_id = aws_route_table.terra-private2.id
}
