output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "task_definition_name" {
  value = aws_ecs_task_definition.this.family
}

output "task_definition_revision" {
  value = aws_ecs_task_definition.this.revision
}

output "ecs_cluster_name" {
  value = var.cluster_name
}
