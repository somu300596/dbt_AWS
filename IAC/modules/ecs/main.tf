resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.family_name
  execution_role_arn       = var.execution_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu #
  memory                   = var.memory #
  network_mode             = "awsvpc"
  container_definitions    = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true
      #secrets   = var.secrets
      # secrets   = [
      #   for secret in var.secrets : {
      #     name      = secret.name
      #     valueFrom = coalesce(secret.valueFrom, null) # Use valueFrom if present
      #   }
      #   if secret.valueFrom != null # Exclude secrets with no valueFrom...
      # ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.log_region
          "awslogs-stream-prefix" = var.log_stream_prefix
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name
  retention_in_days = 7
}
