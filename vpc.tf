resource "aws_vpc" "week-7-project-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "week-7-project-vpc"
  }
}

resource "aws_subnet" "prod-pub-sub-1" {
  vpc_id     = aws_vpc.week-7-project-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-pub-sub-1"
  }
}

resource "aws_subnet" "prod-pub-sub-2" {
  vpc_id     = aws_vpc.week-7-project-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "prod-pub-sub-2"
  }
}

resource "aws_subnet" "prod-priv-sub-1" {
  vpc_id     = aws_vpc.week-7-project-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "prod-priv-sub-1"
  }
}

resource "aws_subnet" "prod-priv-sub-2" {
  vpc_id     = aws_vpc.week-7-project-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "prod-priv-sub-2"
  }
}


resource "aws_route_table" "prod-pub-route-table" {
  vpc_id = aws_vpc.week-7-project-vpc.id
  tags   = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "prod-priv-route-table" {
  vpc_id = aws_vpc.week-7-project-vpc.id
  tags   = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "prod-pub-route-association-1" {
  subnet_id      = aws_subnet.prod-pub-sub-1.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}

resource "aws_route_table_association" "prod-pub-route-association-2" {
  subnet_id      = aws_subnet.prod-pub-sub-2.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}

resource "aws_route_table_association" "prod-priv-route-association-1" {
  subnet_id      = aws_subnet.prod-priv-sub-1.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}

resource "aws_route_table_association" "prod-priv-route-association-2" {
  subnet_id      = aws_subnet.prod-priv-sub-2.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}

resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.week-7-project-vpc.id

  tags = {
    Name = "prod-igw"
  }
}

resource "aws_route" "prod-igw-association" {
  route_table_id            = aws_route_table.prod-pub-route-table.id
  gateway_id                = aws_internet_gateway.prod-igw.id
  destination_cidr_block    = "0.0.0.0/0"
}

resource "aws_eip" "prod-eip" {
  vpc = true
}

resource "aws_nat_gateway" "prod-nat-gateway" {
  allocation_id = aws_eip.prod-eip.id
  subnet_id     = aws_subnet.prod-pub-sub-1.id

  tags = {
    Name = "prod-nat-gateway"
  }
}

resource "aws_route" "prod-nat-association" {
  route_table_id            = aws_route_table.prod-priv-route-table.id
  destination_cidr_block    = "10.0.3.0/24"
  nat_gateway_id            = aws_nat_gateway.prod-nat-gateway.id
}