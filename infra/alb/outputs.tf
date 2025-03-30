output "alb" {
  value = {
    arn                 = aws_alb.public.arn
    id                  = aws_alb.public.id
    zone_id             = aws_alb.public.zone_id
    name                = aws_alb.public.name
    dns_name            = aws_alb.public.dns_name
    http_listener_arn  = aws_alb_listener.http_listener.arn
    # https_listener_arn  = aws_alb_listener.https_listener.arn
    security_group_arn  = aws_security_group.public_alb.arn
    security_group_id   = aws_security_group.public_alb.id
    security_group_name = aws_security_group.public_alb.name
  }
}
