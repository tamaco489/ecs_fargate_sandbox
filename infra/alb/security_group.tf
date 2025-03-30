resource "aws_security_group" "alb" {
  name        = "${local.fqn}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-alb-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-alb-sg-egress"
  }
}

// NOTE: httpsでの接続ができるようになったらこの設定は不要な想定なので削除してよいかも
resource "aws_vpc_security_group_ingress_rule" "alb_http_ingress" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP traffic from anywhere"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "TCP"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-sg-ingress-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_ingress" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS traffic from anywhere"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "TCP"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-sg-ingress-https"
  }
}
