resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/ecs/${aws_ecs_cluster.main.name}"
  retention_in_days = 3

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-ecs-cluster-logs"
  }
}
