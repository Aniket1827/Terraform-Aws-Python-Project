variable "domain_name" {}
variable "aws_load_balancer_dns_name" {}
variable "aws_load_balancer_zone_id" {}

output "hosted-zone-id" {
  value = data.aws_route53_zone.devops-project-hosted-zone.zone_id
}

data "aws_route53_zone" "devops-project-hosted-zone" {
  name = "jhooq.org"
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.devops-project-hosted-zone.zone_id
  name    = var.domain_name
  type    = "A"
  
  alias {
    name = var.aws_load_balancer_dns_name
    zone_id = var.aws_load_balancer_zone_id
    evaluate_target_health = true
  }
}