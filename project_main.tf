#Project 1 VPC Networking
resource "aws_vpc" "Project-VPC" {
  cidr_block       = "10.16.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true


  tags = {
    Name = "Project-VPC"
    Env = "Prod"
  }
}

#Creating Two Public/Private SUBNETS
#PUBLIC SUBNET
resource "aws_subnet" "Project_PubSub1" {
  vpc_id     = aws_vpc.Project-VPC.id
  cidr_block = "10.16.16.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Project_PubSub1"
    Env = "Prod"
  }
}

resource "aws_subnet" "Project_PubSub2" {
  vpc_id     = aws_vpc.Project-VPC.id
  cidr_block = "10.16.8.0/22"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Project_PubSub2"
    Env = "Prod"
  }
}

#Project IT PRIVATE SUBNET
resource "aws_subnet" "Project_PrivSub1" {
  vpc_id     = aws_vpc.Project-VPC.id
  cidr_block = "10.16.12.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Project_PrivSub1"
    Env = "Prod"
  }
}

resource "aws_subnet" "Project_PrivSub2" {
  vpc_id     = aws_vpc.Project-VPC.id
  cidr_block = "10.16.14.0/26"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Poject_PrivSub2"
    Env = "Prod"
  }
}

#CREATING BOTH PUBLIC AND PRIVATE ROUTE TABLE
resource "aws_route_table" "Project_Pub_RT" {
  vpc_id = aws_vpc.Project-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Project-IGW.id
  }

  tags = {
    Name = "Project_Pub_RT"
    Env = "Prod"
  }
}

resource "aws_route_table" "Project-Priv-RT" {
  vpc_id = aws_vpc.Project-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Project-NG.id
  }
  tags = {
    Name = "Project-Priv-RT"
    Env = "Prod"
  }
}

#ASSOCIATING OF ROUTE PUBLIC/PRIVATE TABLES TO THE SUBNETS
resource "aws_route_table_association" "Project-Assoc1" {
  subnet_id      = aws_subnet.Project_PubSub1.id
  route_table_id = aws_route_table.Project_Pub_RT.id
}

resource "aws_route_table_association" "Project-Assoc2" {
  subnet_id      = aws_subnet.Project_PubSub2.id
  route_table_id = aws_route_table.Project_Pub_RT.id
}

resource "aws_route_table_association" "Project-Assoc3" {
  subnet_id      = aws_subnet.Project_PrivSub1.id
  route_table_id = aws_route_table.Project-Priv-RT.id
}

resource "aws_route_table_association" "Project-Assoc4" {
  subnet_id      = aws_subnet.Project_PrivSub2.id
  route_table_id = aws_route_table.Project-Priv-RT.id
}

#CREATION OF INTERNET GATEWAY
resource "aws_internet_gateway" "Project-IGW" {
  vpc_id = aws_vpc.Project-VPC.id
  tags = {
    Name = "Project-IGW"
    Env = "Prod"
  }
}

#CREATION OF NAT GATEWAY
#EIP may require IGW to exist prior to association.
#Use depends_on to set an explicit dependency on the IGW
resource "aws_eip" "Project-EIP" {
  depends_on = [aws_internet_gateway.Project-IGW]
}

resource "aws_nat_gateway" "Project-NG" {
  allocation_id = aws_eip.Project-EIP.id
  subnet_id     = aws_subnet.Project_PubSub1.id
  tags = {
    Name = "Project-NG"
    Env = "Prod"
  }

}

#ASSOCIATING PRIVATE SUBNET 1 WITH PRIVATE ROUTE TABLE 1
#TERRAFORM AWS ASSOCIATE SUBNET WITH ROUTE TABLE
resource "aws_route_table_association" "ProjectPrivRTAssocforNG" {
  subnet_id = aws_subnet.Project_PrivSub1.id
  route_table_id = aws_route_table.Project-Priv-RT.id
}

