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

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  # NOTE: 本番運用の際にはスポットインスタンスだけではなく、FARGATEも確保しておく必要あり。
  capacity_providers = [
    # "FARGATE",
    "FARGATE_SPOT",
  ]

  # default_capacity_provider_strategy {
  #   base              = 1
  #   weight            = 1
  #   capacity_provider = "FARGATE"
  # }

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = "FARGATE_SPOT"
  }
}
