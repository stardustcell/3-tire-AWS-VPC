
################################################################################
# VPC creation
################################################################################


resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "VPC"
  }
}

################################################################################
# Internet gateway creation
################################################################################


resource "aws_internet_gateway" "IGW" {
  depends_on = [
    aws_vpc.my_vpc
  ]

  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "IGW"
  }
}


################################################################################
# Publiс Subnets  2 public subnets for web tire
################################################################################



resource "aws_subnet" "pub_subnet_web" {
  count             = length(var._AZ_zone)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.pub_sub_web_cidr, count.index)
  availability_zone = element(var._AZ_zone, count.index)

  depends_on = [
    aws_vpc.my_vpc
  ]

  tags = {
    Name = "public subnet web ${count.index + 1}",
    
  }

}


################################################################################
# Route table for public subnets
################################################################################


resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.my_vpc.id

  depends_on = [
    aws_vpc.my_vpc
  ]

  tags = { name = "Public route table" }

}



resource "aws_route" "pub_RT_web" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IGW.id
  route_table_id         = aws_route_table.public_RT.id

  depends_on = [
    aws_route_table.public_RT
  ]

}


// route table public subnet association //

resource "aws_route_table_association" "pub_sub_route_association" {
  count          = length(var.pub_sub_web_cidr)
  subnet_id      = element(aws_subnet.pub_subnet_web[*].id, count.index)
  route_table_id = aws_route_table.public_RT.id

  depends_on = [
    aws_route.pub_RT_web
  ]

}


################################################################################
# 2 private subnet for app tire
################################################################################


resource "aws_subnet" "Pri_subnet_app" {
  count             = length(var._AZ_zone)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.Pri_sub_app_cidr, count.index)
  availability_zone = element(var._AZ_zone, count.index)

  depends_on = [
    aws_vpc.my_vpc
  ]

  tags = {
    Name = "private subnet app ${count.index + 1}"
  }
}


// NAT gateway //

resource "aws_eip" "Elastic_ip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.IGW]




}

resource "aws_nat_gateway" "NAT_GW" {

  allocation_id = aws_eip.Elastic_ip.id
  subnet_id     = element(aws_subnet.Pri_subnet_app[*].id, 0)

  depends_on = [
    aws_eip.Elastic_ip
  ]

  tags = {
    Name = "NAT GW"
  }
}

################################################################################
# Route table for private subnet
################################################################################


resource "aws_route_table" "Private_RT_app" {
  vpc_id = aws_vpc.my_vpc.id

  tags = { name = "Private app route table" }

}

resource "aws_route" "pri_route_app" {

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.Private_RT_app.id
  gateway_id             = aws_nat_gateway.NAT_GW.id

  depends_on = [
    aws_route_table.Private_RT_app
  ]

}


resource "aws_route_table_association" "prt_sub_route_association" {
  count          = length(var.Pri_sub_app_cidr)
  subnet_id      = element(aws_subnet.Pri_subnet_app[*].id, count.index)
  route_table_id = aws_route_table.Private_RT_app.id

  depends_on = [
    aws_route.pri_route_app
  ]



}


################################################################################
# Publiс Subnets- 2 private subnet for database tire
################################################################################

////

resource "aws_subnet" "Private_sub_DB" {
  count             = length(var._AZ_zone)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.Pri_sub_db_cidr, count.index)
  availability_zone = element(var._AZ_zone, count.index)

  depends_on = [
    aws_vpc.my_vpc
  ]

  tags = {
    Name = "private subnet db ${count.index + 1}"
  }
}

resource "aws_route_table" "Private_RT_DB" {
  vpc_id = aws_vpc.my_vpc.id

  tags = { name = "Private DB route table" }

}

resource "aws_route" "Private_route_DB" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.NAT_GW.id
  route_table_id         = aws_route_table.Private_RT_DB.id

}

resource "aws_route_table_association" "Private_RT_DB_association" {
  count          = length(var.Pri_sub_db_cidr)
  route_table_id = aws_route_table.Private_RT_DB.id
  subnet_id      = element(aws_subnet.Private_sub_DB[*].id, count.index)


}