variable terget_group_name {}
variable port {}
variable protocol {}
variable "ec2_instance_id" {}
variable "vpc_id" {}

output "aws-lb-target-group-arn" {
  value = aws_lb_target_group.devops-project-lb-target-group.arn
}

resource "aws_lb_target_group" "devops-project-lb-target-group" {
  name     = var.terget_group_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.devops-project-lb-target-group.arn
  target_id        = var.ec2_instance_id
  port             = 5000
}
