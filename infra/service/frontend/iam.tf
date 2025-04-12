// タスク実行ロール（Task Execution Role）
// ECSがタスクを実行する際に必要となる権限を提供するIAM Role。
// AWS マネージドポリシーとして `AmazonECSTaskExecutionRolePolicy` を関連付けている。
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${local.fqn}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
  description        = "IAM Role used by ECS tasks to allow ECS to pull container images and write logs to CloudWatch."

  tags = { Name = "${local.fqn}-ecs-task-execution-role" }
}

// NOTE: AWS マネージドポリシー
// https://docs.aws.amazon.com/ja_jp/aws-managed-policy/latest/reference/AmazonECSTaskExecutionRolePolicy.html
resource "aws_iam_policy_attachment" "ecs_task_execution_policy_attachment" {
  name       = "${local.fqn}-ecs-task-execution-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
}

// タスクロール (Task Role)
// ECSタスク内で実行されるアプリケーションが必要とする権限を提供するIAM Role。
// タスクがAWSリソース（例: S3, DynamoDB, SQS...）にアクセスするために必要な権限を提供する。
// アプリケーションが、実行中にタスク内で必要とされるAPI呼び出しを行うために使用される。
resource "aws_iam_role" "ecs_task_role" {
  name               = "${local.fqn}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
  description        = "IAM Role used by ECS tasks to access AWS resources (S3, DynamoDB, SQS etc.) on behalf of the application."

  tags = { Name = "${local.fqn}-ecs-task-role" }
}

resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${local.fqn}-ecs-task-policy"
  policy      = data.aws_iam_policy_document.ecs_task_policy.json
  description = "Custom IAM policy that provides necessary permissions for ECS tasks to interact with other AWS resources."

  tags = { Name = "${local.fqn}-ecs-task-policy" }
}

resource "aws_iam_policy_attachment" "ecs_task_policy_attachment" {
  name       = "${local.fqn}-ecs-task-policy-attachment"
  policy_arn = aws_iam_policy.ecs_task_policy.arn
  roles      = [aws_iam_role.ecs_task_role.name]
}
