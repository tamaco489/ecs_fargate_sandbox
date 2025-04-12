resource "aws_cloudwatch_log_group" "ecs_frontend_service" {
  name              = "/aws/ecs/${local.fqn}-frontend-service"
  retention_in_days = 3

  tags = { Name = "${local.fqn}-ecs-frontend-service-logs" }
}
