resource "aws_cloudwatch_log_group" "ecs_cluster" {
  name              = "/aws/ecs/${local.fqn}-cluster"
  retention_in_days = 3

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-ecs-cluster-logs"
  }
}
