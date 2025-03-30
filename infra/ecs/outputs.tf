output "ecs_cluster" {
  description = "ECS Cluster details"
  value = {
    name = aws_ecs_cluster.main.name
    arn  = aws_ecs_cluster.main.arn
    id   = aws_ecs_cluster.main.id
  }
}
