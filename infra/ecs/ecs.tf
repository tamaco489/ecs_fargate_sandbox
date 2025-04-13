resource "aws_ecs_cluster" "main" {
  name = "${local.fqn}-cluster"

  setting {
    // NOTE: オブザーバビリティが強化された Container Insights（推奨設定）
    name  = "containerInsights"
    value = "enhanced"
  }

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        // 暗号化はAWSが提供するKMSキーを利用する
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cluster.name
      }
    }
  }

  tags = { Name = "${local.fqn}-ecs-cluster" }
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
