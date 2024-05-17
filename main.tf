output "public_subnets" {
  value = tolist(module.networking.devops_project_public_subnets)[0]
}
module "networking" {
    source               = "./networking"
    vpc_cidr             = var.vpc_cidr
    vpc_name             = var.vpc_name
    public_subnet_cidr   = var.public_subnet_cidr
    availability_zones   = var.availability_zones
    private_subnet_cidr  = var.private_subnet_cidr
}

module "security" {
    source = "./security"
    vpc_id = module.networking.devops-project-vpc-id
    ec2_security_group_name           = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
}

module "ec2-instance" {
  source = "./python-ec2"
  ami_id = var.ec2_ami_id
  instance_type = "t2.micro"
  public_key = var.public_key
  subnet_id = tolist(module.networking.devops_project_public_subnets)[0]
  security_group_for_python = [module.security.sg_ec2_sg_ssh_http_id, module.security.sg_ec2_rds_mysql]
  enable_public_ip_address = true
  user_data_install_python = templatefile("./python-runner-script/python-installer.sh", {})
}

module "load-balancer-target-group" {
  source = "./load-balancer-target-group"
  terget_group_name = "devops-project-load-balancer"
  port = 8080
  protocol = "HTTP"
  vpc_id = module.networking.devops-project-vpc-id
  ec2_instance_id = module.ec2-instance.python_ec2_instance_id
}

module "load-balancer" {
  source = "./load-balancer"
  load_balancer_name = "devops-project-load-balancer"
  external = false
  load_balancer_type = "application"
  ssh_https_secutiy_group = module.security.sg_ec2_sg_ssh_http_id
  subnet_ids = tolist(module.networking.devops_project_public_subnets)
  load_balancer_target_group_arn = module.load-balancer-target-group.aws-lb-target-group-arn
  ec2_instance_id = module.ec2-instance.python_ec2_instance_id
  load_balancer_listener_deault_action = "forward"
  load_balancer_listener_port = 8080
  load_balancer_listener_protocol = "HTTP"
  load_balancer_https_listener_port = 443
  load_balancer_https_protocol = "HTTPS"
  load_balancer_target_group_attachment_port = 8080
}

module "hosted-zone" {
  source = "./hosted-zone"
  domain_name = "python.jhooq.org"
  aws_load_balancer_dns_name = module.load-balancer.load_balancer_dns_name
  aws_load_balancer_zone_id = module.load-balancer.load_balancer_zone_id
}