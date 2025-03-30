resource "aws_ecs_cluster" "main" {
  name = "${local.fqn}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-ecs-cluster"
  }
}
