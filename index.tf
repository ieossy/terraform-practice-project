

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

variable "practice_vpc_cidr_block" {
  description = "us east 1 vpc"
}
variable "practice_subnet_cidr_block" {
  description = "us east 1a subnet"
}
variable "subnet_az" {
  description = "subnet az"
}
variable "env-prefix" {

}

resource "aws_vpc" "practice-vpc-1" {
  cidr_block       = var.practice_vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name  = "${var.env-prefix}-vpc"
    "key" = "${var.env-prefix}-vpc"
  }

}

resource "aws_subnet" "practice-subnet" {
  vpc_id            = aws_vpc.practice-vpc-1.id
  cidr_block        = var.practice_subnet_cidr_block
  availability_zone = var.subnet_az
  tags = {
    "key" = "${var.env-prefix}-subnet-1a"
    Name  = "${var.env-prefix}-subnet-1a"
  }

}

resource "aws_internet_gateway" "practice-igw" {
  vpc_id = aws_vpc.practice-vpc-1.id 

  tags = {
    "key" = "${var.env-prefix}-igw"
    Name  = "${var.env-prefix}-igw"
  }
}

resource "aws_route_table" "tf-practice-rt" {

  vpc_id = aws_vpc.practice-vpc-1
  route = [ {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.practice-igw.id
  } ]

  tags = {
    "key" = "${var.env-prefix}-rt"
    Name  = "${var.env-prefix}-rt"
  }
}


output "vpc-id" {
  value = aws_vpc.practice-vpc-1.id
}

output "subnet-id" {
  value = aws_subnet.practice-subnet.id
  
}



