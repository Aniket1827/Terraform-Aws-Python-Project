variable "ami_id" {}
variable "instance_type" {}
variable "public_key" {}
variable "subnet_id" {}
variable "security_group_for_python" {}
variable "enable_public_ip_address" {}
variable "user_data_install_python" {}

output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i /home/aniket/devops-project ubuntu@", aws_instance.python-ec2-instance-ip.public_ip)
}

output "python_ec2_instance_id" {
  value = aws_instance.python-ec2-instance-ip.id
}

output "dev_proj_1_ec2_instance_public_ip" {
  value = aws_instance.python-ec2-instance-ip.public_ip
}

resource "aws_instance" "python-ec2-instance-ip" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = "aws_ec2"                     # Private key generated on local machine to ssh into machine
    vpc_security_group_ids = var.security_group_for_python
    subnet_id = var.subnet_id
    associate_public_ip_address = var.enable_public_ip_address
    user_data = var.user_data_install_python
}

resource "aws_key_pair" "jekins-ec2-instance-public-key" {
  key_name = "aws_ec2"
  public_key = var.public_key
}