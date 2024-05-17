variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "public_key" {
  type = string
}

variable "ec2_ami_id" {
  type = string
}