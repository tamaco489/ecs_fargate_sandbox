# DOC: [AWS] https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
# DOC: [terraform] https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "frontend_service" {
  family                   = "${local.fqn}-frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      # NOTE: nginxへのテストアクセス成功後に変更する
      # name      = "${local.fqn}-frontend"
      # image     = "${data.terraform_remote_state.ecr.outputs.frontend_service.url}:${var.env}"
      name      = "nginx"
      image     = "nginx:1.14"
      cpu       = 256
      memory    = 512
      essential = true // コンテナが停止した際にタスク全体も停止させる

      # NOTE: nginxへのテストアクセス成功後に変更する
      # portMappings = [
      #   {
      #     containerPort = 3000
      #     protocol      = "tcp"
      #   }
      # ]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_frontend_service.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = { Name = "${local.fqn}-ecs-frontend-service-task-definition" }
}
