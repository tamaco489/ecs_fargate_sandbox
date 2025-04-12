resource "aws_ecr_repository" "frontend_service" {
  name                 = "${local.fqn}-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = { Name = "${local.fqn}-ecr-frontend_service" }
}

# ポリシー
# セマンティックバージョニングのタグ付きイメージを5世代保持
# stgタグ付きイメージは最新世代のみ保持
# タグ付けされていないイメージを1日で削除
# セマンティックバージョニング以外のタグが付いたイメージを30日で削除
resource "aws_ecr_lifecycle_policy" "frontend_service" {
  repository = aws_ecr_repository.frontend_service.name

  policy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 1,
          "description" : "Maintain 5 images with versions, with the oldest being deleted when the 6th image is uploaded",
          "selection" : {
            "tagStatus" : "tagged",
            "tagPrefixList" : ["frontend_v"],
            "countType" : "imageCountMoreThan",
            "countNumber" : 5
          },
          "action" : {
            "type" : "expire"
          }
        },
        {
          "rulePriority" : 2,
          "description" : "Keep only the latest stg tagged image",
          "selection" : {
            "tagStatus" : "tagged",
            "tagPrefixList" : ["stg"],
            "countType" : "imageCountMoreThan",
            "countNumber" : 1,
          },
          "action" : {
            "type" : "expire"
          }
        },
        {
          "rulePriority" : 3,
          "description" : "Delete untagged images in a day",
          "selection" : {
            "tagStatus" : "untagged",
            "countType" : "sinceImagePushed",
            "countUnit" : "days",
            "countNumber" : 1
          },
          "action" : {
            "type" : "expire"
          }
        },
        {
          "rulePriority" : 4,
          "description" : "Delete other tagged images in 7 days",
          "selection" : {
            "tagStatus" : "any",
            "countType" : "sinceImagePushed",
            "countUnit" : "days",
            "countNumber" : 7
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  )
}