resource "aws_appautoscaling_target" "frontend_service" {
  # 対象サービスの名前空間(必須項目) ※ECSの場合は「ecs」固定
  service_namespace = "ecs"

  # スケーリング対象のリソースと属性を指定 ※ECSサービスのタスク数 (desired count)
  scalable_dimension = "ecs:service:DesiredCount"

  # スケールアウト時の最大タスク数 (2), スケールイン時の最小タスク数 (1)
  max_capacity = 2
  min_capacity = 1

  # スケーリング対象のリソースを指定
  resource_id = "service/${data.terraform_remote_state.ecs.outputs.ecs_cluster.name}/${aws_ecs_service.frontend_service.name}"
}

resource "aws_appautoscaling_policy" "frontend_service_cpu" {
  name               = "${local.fqn}-frontend-cpu-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.frontend_service.resource_id
  scalable_dimension = aws_appautoscaling_target.frontend_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.frontend_service.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    # 平均CPU使用率が75%を超えたらスケーリング
    target_value = 75.0

    # リソースが高騰して過剰にスケーリングしないように、追加/削除した効果を待ってからスケーリングするように設定
    scale_in_cooldown  = 60 # スケールイン (減らす)
    scale_out_cooldown = 60 # スケールアウト (増やす)
  }
}

resource "aws_appautoscaling_policy" "frontend_service_memory" {
  name               = "${local.fqn}-frontend-memory-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.frontend_service.resource_id
  scalable_dimension = aws_appautoscaling_target.frontend_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.frontend_service.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    # 平均メモリ使用率が75%を超えたらスケーリング
    target_value = 75.0

    # スケーリング頻度を抑えるためのクールダウン
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
