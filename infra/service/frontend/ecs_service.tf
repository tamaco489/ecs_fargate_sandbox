# DOC: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "frontend_service" {
  name                               = "${local.fqn}-frontend"
  cluster                            = data.terraform_remote_state.ecs.outputs.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.frontend_service.arn
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  availability_zone_rebalancing      = "DISABLED"

  # ECS Exec 機能の有効化
  enable_execute_command = true

  # ECSサービスが維持すべきタスク（コンテナ）の数を指定（常に1つのタスクが稼働している状態を維持する）
  desired_count = 1

  network_configuration {
    # NOTE: public通信可能な状態になり次第、private通信に切り替える
    # subnets = data.terraform_remote_state.network.outputs.vpc.private_subnet_ids
    subnets = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids

    # NOTE: SG設定後に追加
    security_groups  = [aws_security_group.frontend_service.id]
    assign_public_ip = true # todo: private通信に切り替えた後（つまりNAT Gateway経由でのアクセス）にfalseに変更する
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.frontend_service.arn
    # NOTE: nginxへのテストアクセス成功後に変更する
    # container_name   = "${local.fqn}-frontend"
    # container_port   = 3000
    container_name   = "nginx"
    container_port   = 80
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = { Name = "${local.fqn}-ecs-frontend-service" }
}

resource "aws_appautoscaling_target" "frontend_service" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${data.terraform_remote_state.ecs.outputs.ecs_cluster.name}/${aws_ecs_service.frontend_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# resource "aws_appautoscaling_policy" "frontend_service_cpu" {
#   #
# }

# resource "aws_appautoscaling_policy" "frontend_service_memory" {
#   #
# }
