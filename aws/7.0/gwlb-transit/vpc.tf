// AWS VPC - FortiGate
resource "aws_vpc" "fgtvm-vpc" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = {
    Name = "FGT-GWLB-VPC"
  }
}

resource "aws_subnet" "publicsubnetaz1" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.publiccidraz1
  availability_zone = var.az1
  tags = {
    Name = "fgt public subnet az1"
  }
}
//
resource "aws_subnet" "publicsubnetaz2" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.publiccidraz2
  availability_zone = var.az2
  tags = {
    Name = "fgt public subnet az2"
  }
}

resource "aws_subnet" "privatesubnetaz1" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.privatecidraz1
  availability_zone = var.az1
  tags = {
    Name = "fgt private subnet az1"
  }
}

resource "aws_subnet" "privatesubnetaz2" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.privatecidraz2
  availability_zone = var.az2
  tags = {
    Name = "fgt private subnet az2"
  }
}

resource "aws_subnet" "transitsubnetaz1" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.attachcidraz1
  availability_zone = var.az1
  tags = {
    Name = "fgt transit attach subnet az1"
  }
}

resource "aws_subnet" "transitsubnetaz2" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.attachcidraz2
  availability_zone = var.az2
  tags = {
    Name = "fgt transit attach subnet az2"
  }
}
resource "aws_subnet" "gwlbsubnetaz1" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.gwlbcidraz1
  availability_zone = var.az1
  tags = {
    Name = "fgt gwlb subnet az1"
  }
}

resource "aws_subnet" "gwlbsubnetaz2" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.gwlbcidraz2
  availability_zone = var.az2
  tags = {
    Name = "fgt gwlb subnet az2"
  }
}