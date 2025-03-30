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
  preserve_host_header = true

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-alb"
  }
}
