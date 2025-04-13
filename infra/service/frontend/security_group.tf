# Frontend Client Security Group
resource "aws_security_group" "frontend_service" {
  name        = "${local.fqn}-frontend"
  description = "Security group for frontend service"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id
  tags        = { Name = "${local.fqn}-ecs-frontend-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "frontend_service" {
  security_group_id = aws_security_group.frontend_service.id
  description       = "Allow HTTP from ALB"
  # NOTE: nginxへのテストアクセス成功後に変更する
  # from_port                    = 3000
  # to_port                      = 3000
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = data.terraform_remote_state.alb.outputs.alb.security_group_id
}

resource "aws_vpc_security_group_egress_rule" "frontend_service" {
  security_group_id = aws_security_group.frontend_service.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
