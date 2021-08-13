

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

variable "practice_vpc_cidr_block" {
  description = "us east vpc"
}
variable "default_route_block" {
  description = "cidr block for default route table"
}
variable "ssh-port" {
  description = "ingress rule for ssh port"
}
variable "http-port" {}
variable "http-cidr-blocks" {
  
}
variable "ssh-cidr-blocks" {
  description = "ssh-cidr-blocks"
  
}
variable "practice_subnet_cidr_block" {
  description = "us east 1a subnet"
}
variable "subnet_az" {
  description = "subnet az"
}
variable "env-prefix" {

}

resource "aws_vpc" "practice-vpc" {
  cidr_block       = var.practice_vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name  = "${var.env-prefix}-vpc"
    "key" = "${var.env-prefix}-vpc"
  }

}

resource "aws_subnet" "practice-subnet" {
  vpc_id            = aws_vpc.practice-vpc.id 
  cidr_block        = var.practice_subnet_cidr_block
  availability_zone = var.subnet_az
  tags = {
    "key" = "${var.env-prefix}-subnet-1a"
    Name  = "${var.env-prefix}-subnet-1a"
  }

}

resource "aws_internet_gateway" "practice-igw" {
  vpc_id = aws_vpc.practice-vpc.id

  tags = {
    "key" = "${var.env-prefix}-igw"
    Name  = "${var.env-prefix}-igw"
  }
}

# resource "aws_route_table" "tf-practice-rt" {

#   vpc_id = aws_vpc.practice-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.practice-igw.id
#   }

#   tags = {
#     "key" = "${var.env-prefix}-rt"
#     Name  = "${var.env-prefix}-rt"
#   }
# }

# resource "aws_route_table_association" "association" {
#   subnet_id = aws_subnet.practice-subnet.id
#   route_table_id = aws_route_table.tf-practice-rt.id
# }


resource "aws_default_route_table" "practice-main-rt" {
  default_route_table_id = aws_vpc.practice-vpc.default_route_table_id
  route {
    cidr_block = var.default_route_block
    gateway_id = aws_internet_gateway.practice-igw.id
  }
  tags = {
   "key" = "${var.env-prefix}-main-rt"
    Name  = "${var.env-prefix}-main-rt"
  }
}

resource "aws_security_group" "practice-sg" {
  vpc_id = aws_vpc.practice-vpc.id

  ingress {
    description = "ingress rule for ssh port"
    from_port = var.ssh-port
    to_port = var.ssh-port
    protocol = "tcp"
    cidr_blocks = var.ssh-cidr-blocks
  }
  ingress {
    description = "ingress rule for http"
    from_port = var.http-port
    to_port = var.http-port
    protocol = "tcp"
    cidr_blocks = var.http-cidr-blocks
  }
  egress {
    description = "egress rule for out bound traffic for the instance"
    from_port = 0
    to_port = 0
    protocol = "-1" // all protocols
    cidr_blocks = var.http-cidr-blocks
    prefix_list_ids = [] // for access to vpc end points
  }
    tags = {
      Name = "${var.env-prefix}-practice-sg"
      "key" = "${var.env-prefix}-practice-sg"
    }
}

output "vpc-id" {
  value = aws_vpc.practice-vpc.id
}

output "subnet-id" {
  value = aws_subnet.practice-subnet.id

}



