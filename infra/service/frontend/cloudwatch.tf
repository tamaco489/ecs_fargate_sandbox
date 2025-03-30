resource "aws_cloudwatch_log_group" "ecs_frontend_service" {
  name              = "/aws/ecs/${local.fqn}-frontend-service"
  retention_in_days = 3

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-ecs-frontend-service-logs"
  }
}
