output "acm" {
  value = {
    id   = aws_acm_certificate.ecs_fargate_sandbox.id
    arn  = aws_acm_certificate.ecs_fargate_sandbox.arn
    name = aws_acm_certificate.ecs_fargate_sandbox.domain_name
  }
}
