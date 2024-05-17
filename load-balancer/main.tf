variable "load_balancer_name" {}
variable "load_balancer_type" {}
variable "external" { default = false }
variable "ssh_https_secutiy_group" {}
variable "subnet_ids" {}
variable "load_balancer_target_group_arn" {}
variable "ec2_instance_id" {}
variable "load_balancer_listener_port" {}
variable "load_balancer_listener_deault_action" {}
variable "load_balancer_https_listener_port" {}
variable "load_balancer_https_protocol" {}
variable "load_balancer_listener_protocol" {}
variable "load_balancer_target_group_attachment_port" {}


output "load_balancer_dns_name" {
  value = aws_lb.devops-project-load-balancer.dns_name
}

output "load_balancer_zone_id" {
  value = aws_lb.devops-project-load-balancer.zone_id
}


resource "aws_lb" "devops-project-load-balancer" {
  name               = var.load_balancer_name
  internal           = true
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.ssh_https_secutiy_group]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Environment = "development"
  }
}

resource "aws_lb_target_group_attachment" "devops-project-load-balancer-target-group-attachment" {
  target_group_arn = var.load_balancer_target_group_arn
  target_id        = var.ec2_instance_id
  port             = var.load_balancer_target_group_attachment_port
}

resource "aws_lb_listener" "devops-project-load-balancer-listener" {
  load_balancer_arn = aws_lb.devops-project-load-balancer.arn
  port              = var.load_balancer_listener_port
  protocol          = var.load_balancer_listener_protocol
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = var.load_balancer_listener_deault_action
    target_group_arn = var.load_balancer_target_group_arn
  }
}

resource "aws_lb_listener" "devops-project-load-balancer-https-listener" {
  load_balancer_arn = aws_lb.devops-project-load-balancer.arn
  port              = var.load_balancer_https_listener_port
  protocol          = var.load_balancer_https_protocol
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = var.load_balancer_listener_deault_action
    target_group_arn = var.load_balancer_target_group_arn
  }
}