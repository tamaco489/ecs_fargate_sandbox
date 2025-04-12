output "frontend_service" {
  value = {
    arn  = aws_ecr_repository.frontend_service.arn
    id   = aws_ecr_repository.frontend_service.id
    name = aws_ecr_repository.frontend_service.name
    url  = aws_ecr_repository.frontend_service.repository_url
  }
}
