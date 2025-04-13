resource "aws_alb_target_group" "frontend_service" {
  name        = "${local.fqn}-frontend"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip" # NOTE: ECS on Fargate 構成の場合各タスクがENIによる独立したプライベートIDを持つため
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = { Name = "${local.fqn}-ecs-frontend-alb-target-group" }
}

resource "aws_alb_listener_rule" "frontend_service" {
  listener_arn = data.terraform_remote_state.alb.outputs.alb.https_listener_arn

  # 優先順位の指定、値の小さいものを優先的に評価される
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.frontend_service.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  tags = { Name = "${local.fqn}-ecs-frontend-alb-listener-rule" }
}
