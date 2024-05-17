# Fetch required varibales
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {} 
variable "availability_zones" {}

output "devops-project-vpc-id" {
  value = aws_vpc.devops-project-vpc.id
}

output "devops_project_public_subnets" {
  value = aws_subnet.devops_project_public_subnets.*.id
}

output "devops-project-public-subnet-cidr-block" {
  value = aws_subnet.devops_project_public_subnets.*.cidr_block
}

# Define vpc configurations
resource "aws_vpc" "devops-project-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

# Define public subnets
resource "aws_subnet" "devops_project_public_subnets" {
  count = length(var.public_subnet_cidr)                                 # To iterate over an array, ads pubic_subnet_cidr variable is an array
  vpc_id     = aws_vpc.devops-project-vpc.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "devops-project-public-subnet-${count.index + 1}"
  }
}

# Define private subnets
resource "aws_subnet" "devops-project-private-subnets" {
  count = length(var.private_subnet_cidr)                                 # To iterate over an array, ads pubic_subnet_cidr variable is an array
  vpc_id     = aws_vpc.devops-project-vpc.id
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "devops-project-private-subnet-${count.index + 1}"
  }
}

# Define IG Configurations
resource "aws_internet_gateway" "devops-project-internet-gateway" {
  vpc_id = aws_vpc.devops-project-vpc.id

  tags = {
    Name = "devops-project-internet-gateway"
  }
}

# Define route table for public subnet
resource "aws_route_table" "devops-project-public-subnet-route-table" {
  vpc_id = aws_vpc.devops-project-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-project-internet-gateway.id
  }

  tags = {
    Name = "devops-project-public-subnet-rt"
  }
}

# Public Route Table & Public Subnet Association
resource "aws_route_table_association" "devops-project-public-subnet-rt-assn" {
  count = length(aws_subnet.devops_project_public_subnets)
  subnet_id = aws_subnet.devops_project_public_subnets[count.index].id
  route_table_id = aws_route_table.devops-project-public-subnet-route-table.id
}

# Define route table for private subnet
resource "aws_route_table" "devops-project-private-subnet-route-table" {
  vpc_id = aws_vpc.devops-project-vpc.id

  tags = {
    Name = "devops-project-private-subnet-rt"
  }
}

# Public Route Table & Private Subnet Association
resource "aws_route_table_association" "devops-project-private-subnet-rt-assn" {
  count = length(aws_subnet.devops-project-private-subnets)
  subnet_id = aws_subnet.devops-project-private-subnets[count.index].id
  route_table_id = aws_route_table.devops-project-private-subnet-route-table.id
}