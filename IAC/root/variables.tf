variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "iam_role_name" {
  description = "Name of the IAM role for ECS task execution"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_family_name" {
  description = "Name of the ECS task family"
  type        = string
}

variable "cpu" {
  description = "The value of cpu"
  type        = string
}

variable "memory" {
  description = "The value of memory"
  type        = string
}

variable "ecs_container_name" {
  description = "Name of the ECS container"
  type        = string
}

variable "env_var" {
  description = "List of environment var for ECS task definition"
  type = list(object({
    name      = string
    value     = string
  }))
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket with versioning enabled"
  type        = string
}

variable "security_group_name" {
  description = "Name of the ECR repository"
  type        = string
}
########Airflow Variables
variable "environment_name" {}
variable "airflow_version" {}
variable "dag_s3_path" {}
variable "subnet_ids" {}
variable "max_workers" {}
variable "min_workers" {}
variable "webserver_access_mode" {}
variable "enable_dag_processing_logs" {}
variable "dag_processing_log_level" {}
variable "enable_scheduler_logs" {}
variable "scheduler_log_level" {}
variable "enable_task_logs" {}
variable "task_log_level" {}
variable "enable_webserver_logs" {}
variable "webserver_log_level" {}
variable "enable_worker_logs" {}
variable "worker_log_level" {}
variable "weekly_maintenance_window_start" {}
variable "tags" {}
