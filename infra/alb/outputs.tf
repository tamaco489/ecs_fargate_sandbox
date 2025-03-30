output "alb" {
  value = {
    arn                 = aws_alb.main.arn
    id                  = aws_alb.main.id
    zone_id             = aws_alb.main.zone_id
    name                = aws_alb.main.name
    dns_name            = aws_alb.main.dns_name
    http_listener_arn  = aws_alb_listener.http_listener.arn
    # https_listener_arn  = aws_alb_listener.https_listener.arn
    security_group_arn  = aws_security_group.alb.arn
    security_group_id   = aws_security_group.alb.id
    security_group_name = aws_security_group.alb.name
  }
}
