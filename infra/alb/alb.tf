resource "aws_alb" "main" {
  name               = "${local.fqn}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
  security_groups    = [aws_security_group.alb.id]

  ip_address_type            = "ipv4"
  drop_invalid_header_fields = true
  idle_timeout               = 60 * 5 // 5 seconds
  client_keep_alive          = 60 * 5 // デフォルトだと3600になるがアイドル時間を10分が優先され混乱するので明示的に指定（ssrのため長時間維持する必要ない想定）
  enable_http2               = true
  preserve_host_header       = true

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-alb"
  }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  // NOTE: デフォルトアクションは一旦検証のため200で設定、後で404に変える
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      status_code  = "200"
      message_body = jsonencode({
        message = "ok"
        status  = "success"
      })
    }
  }

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-alb-http-listener"
  }
}
