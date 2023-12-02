
// nacl //

# nacl for public subnet


resource "aws_network_acl" "public_NACL" {

  vpc_id = aws_vpc.my_vpc.id

  depends_on = [
    aws_subnet.pub_subnet_web
  ]
  egress {
      protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
 
  ingress {

    protocol   = "icmp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1
    to_port    = 100

  }
 tags = {name= "pubic NACL"}

}

// nacl association for public subnets

resource "aws_network_acl_association" "pub_sub_nacl_association" {
  count          = length(var.pub_sub_web_cidr)
  network_acl_id = aws_network_acl.public_NACL.id
  subnet_id      = element(aws_subnet.pub_subnet_web[*].id, count.index)

  depends_on = [
    aws_network_acl.public_NACL
  ]

}

# nacl for private subnet


resource "aws_network_acl" "private_NACL" {
  vpc_id = aws_vpc.my_vpc.id

  depends_on = [
    aws_subnet.Pri_subnet_app
  ]


  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {

    protocol   = "icmp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 1
    to_port    = 100

  }
 tags = {name= "Private NACL"}

}
// nacl association for public subnets
################################################################################
# Public Network ACLs
################################################################################


resource "aws_network_acl_association" "pri_sub_nacl_association" {
  count          = length(var.Pri_sub_app_cidr)
  network_acl_id = aws_network_acl.private_NACL.id
  subnet_id      = element(aws_subnet.Pri_subnet_app[*].id, count.index)

  depends_on = [
    aws_network_acl.private_NACL
  ]

}

# security group

resource "aws_security_group" "SG_for_pub_ec2" {
  vpc_id = aws_vpc.my_vpc.id
  name   = " public SG"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "public sg"
  }
}

