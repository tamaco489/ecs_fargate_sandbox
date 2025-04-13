resource "aws_route53_zone" "ecs_fargate_sandbox" {
  name    = var.domain
  comment = "ECS (Fargate) の検証で利用"
  tags    = { Name = "${var.env}-${var.project}" }
}
