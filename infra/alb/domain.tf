resource "aws_route53_record" "frontend_service" {
  zone_id = data.terraform_remote_state.route53.outputs.host_zone.id
  name    = "www.${data.terraform_remote_state.route53.outputs.host_zone.name}"
  type    = "A"

  alias {
    name                   = aws_alb.public.dns_name
    zone_id                = aws_alb.public.zone_id
    evaluate_target_health = true
  }
}
