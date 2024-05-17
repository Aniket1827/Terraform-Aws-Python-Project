variable "ec2_security_group_name"  {}
variable "vpc_id" {}

output "sg_ec2_sg_ssh_http_id" {
  value = aws_security_group.ec2_sg_ssh_http.id
}

output "sg_ec2_rds_mysql" {
  value = aws_security_group.rds-mysql-security-group.id
}

resource "aws_security_group" "ec2_sg_ssh_http" {
  vpc_id = var.vpc_id
  name = var.ec2_security_group_name


  ingress {
    description = "Allow SSh request from anywhere"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self      = true
    from_port = 22
    to_port   = 22
  }

  ingress {
    description = "Allow HTTP request from anywhere"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self      = true
    from_port = 80
    to_port   = 80
  }

  ingress {
     description = "Allow HTTP request from anywhere"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self      = true
    from_port = 443
    to_port   = 443
  }

  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Groups to allow SSH(22) and HTTP(80)"
  }
}

resource "aws_security_group" "rds-mysql-security-group" {
  name        = "rds-mysql-security-group"
  description =  "Allow access to RDS from EC2 present in public subnet"
  vpc_id      = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow 8080 port to access python"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  tags = {
    Name = "Security Groups to allow SSH(22) and HTTP(80)"
  }
}

resource "aws_security_group" "ec2_sg_python_api" {
  name        = "SG for EC2 for enabling port 5000"
  description = "Enable the Port 5000 for python api"
  vpc_id      = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow traffic on port 5000"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
  }

  tags = {
    Name = "Security Groups to allow traffic on port 5000"
  }
}