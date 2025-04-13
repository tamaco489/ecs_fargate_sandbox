output "host_zone" {
  value = {
    id   = aws_route53_zone.ecs_fargate_sandbox.id,
    name = aws_route53_zone.ecs_fargate_sandbox.name
  }
}
