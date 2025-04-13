resource "aws_alb" "public" {
  name               = "${local.fqn}-public-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
  security_groups    = [aws_security_group.public_alb.id]

  ip_address_type            = "ipv4"
  drop_invalid_header_fields = true
  idle_timeout               = 60 * 5 // 5 seconds
  client_keep_alive          = 60 * 5 // デフォルトだと3600になるがアイドル時間を10分が優先され混乱するので明示的に指定（ssrのため長時間維持する必要ない想定）
  enable_http2               = true
  preserve_host_header       = true

  tags = { Name = "${local.fqn}-public-alb" }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.public.arn
  port              = 80
  protocol          = "HTTP"

  # NOTE: port:80 (HTTP) にアクセスが来た場合は、port:443 (HTTPS) にリダイレクトさせる ※常時HTTPS化（HTTP Strict）のための設定
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = { Name = "${local.fqn}-public-alb-http-listener" }
}

resource "aws_alb_listener" "https_listener" {
  load_balancer_arn = aws_alb.public.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.terraform_remote_state.acm.outputs.acm.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      status_code  = "404"
      message_body = jsonencode({
        status  = "error"
        message = "not found"
      })
    }
  }

  tags = { Name = "${local.fqn}-public-alb-https-listener" }
}
