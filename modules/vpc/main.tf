# Create VPC

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"

  }
}

#Create Public subnet

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = {

    Name = "public-subnet-${count.index+1}"
  }
}
#Create Private subnet

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = {

    Name = "private-subnet-${count.index+1}"
  }
}
#Create Internet Gateway & attach to VPC

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

# Create Elastic Ip for ngw

resource "aws_eip" "ngw" {
  domain ="vpc"

  tags ={
    Name= "ngw "

  }

}
# Create Nat Gateway ann attach to public subnet with elastic ip

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${var.env}-ngw"
  }
}
# Create PVC Peering

resource "aws_vpc_peering_connection" "peering" {
  peer_owner_id = var.account_no
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept = true
  tags = {
    Name ="peering from default to-${var.env}-pvc"

  }
}
# Create Public RT

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

# Attach IGW to public subnet

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

# Create Private RT

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

# Attach NGW to private subnets

  route {
    cidr_block = "0.0.0.0/24"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

# Create peering connection to private RT

  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id

  }

  tags = {
    Name = "private"
  }
}
# create peering connection default RT from default VPC

resource "aws_route" "default-route-table" {
  route_table_id            = var.default_route_table_id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}
# Create Public RT and attach to public subnets

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}
# Create Private RT and attach to private subnets

resource "aws_route_table_association" "private" {
  count = length(var.public_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}