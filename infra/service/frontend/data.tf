data "terraform_remote_state" "ecs" {
  backend = "s3"
  config = {
    bucket = "${var.env}-ssr-web-application-tfstate"
    key    = "ecs/terraform.tfstate"
  }
}

// Assume Role Policyを作成
// このポリシーは ECS タスクが IAM ロールを引き受けることを許可します。
// ECS タスクは `ecs-tasks.amazonaws.com` サービスによってロールを引き受ける必要があり、
// これにより ECS タスクに関連する権限を他のリソースに委任できます。
data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

// ECSタスク向けのIAM Policy向けの定義
// アプリケーション側でAWSリソースを操作する機能が追加された場合、こちらのPolicyに適切な権限を付与していく。
data "aws_iam_policy_document" "ecs_task_policy" {
  // ECS Exec 用のポリシー
  // このポリシーは、ECS Exec 機能を使用して、ECS タスク内で実行されるコンテナに対するSSM メッセージの操作を許可します。
  // 特に、ECS Exec はタスク内でインタラクティブなセッションを開くために `ssmmessages` サービスの API を使用します。
  statement {
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}
