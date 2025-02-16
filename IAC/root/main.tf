# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
#   required_version = ">= 1.4.0" # Minimum Terraform version
# } ###sdd
provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source           = "../modules/ecr"
  repository_name  = var.ecr_repository_name
}

module "ecs_task_execution_role" {
  source              = "../modules/IAM"
  role_name           = "ecs-task-execution-role"
  policy_name         = "ecs-task-execution-policy"
  policy_description  = "Policy for ECS task execution role"
  bucket_arn         = module.s3_bucket.bucket_arn
  assume_role_policy  = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  }
  policy_statements = [
    {
      Effect   = "Allow"
      Action   = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = ["*"]
    },
    {
      Effect = "Allow"
      Action = ["secretsmanager:GetSecretValue"]
      Resource = [
        "arn of secretsmanager"
      ]
    }
  ]
}

module "mwaa_role" {
  source             = "../modules/IAM"
  role_name          = "mwaa-role"
  policy_name        = "mwaa-policy"
  policy_description = "Policy for MWAA"
  bucket_arn         = module.s3_bucket.bucket_arn
  assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "airflow-env.amazonaws.com",
            "airflow.amazonaws.com"
          ]
        }
        Action = ["sts:AssumeRole"]
      }
    ]
  }
  
  policy_statements = [
    {
      Effect = "Allow"
      Action = [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:GetBucketPublicAccessBlock",
        "s3:PutObject"
      ]
      Resource = [
      module.s3_bucket.bucket_arn,          # Bucket ARN
      "${module.s3_bucket.bucket_arn}/*"    # Bucket ARN with objects
    ]
    },
    {
      Effect = "Allow"
      Action = [
        "ecs:RunTask",
        "ecs:DescribeTasks",
        "ecs:ListTasks",
        "ecs:StopTask",
        "iam:PassRole",
        "ecs:ListClusters",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs"
      ]
      Resource = ["*"]
    },
    {
      Effect = "Deny"
      Action = ["s3:ListAllMyBuckets"]
      Resource = [
      module.s3_bucket.bucket_arn,          # Bucket ARN
      "${module.s3_bucket.bucket_arn}/*"    # Bucket ARN with objects....
    ]
    },
    {
      Effect = "Allow"
      Action = [
        "s3:GetObject*",
        "s3:GetBucket*",
        "s3:List*"
      ]
      Resource = [
      module.s3_bucket.bucket_arn,          # Bucket ARN
      "${module.s3_bucket.bucket_arn}/*"    # Bucket ARN with objects
    ]
    },
    {
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:PutLogEvents",
        "logs:GetLogEvents",
        "logs:GetLogRecord",
        "logs:GetLogGroupFields",
        "logs:GetQueryResults"
      ]
      Resource = ["*"]
    },
    {
      Effect = "Allow"
      Action = [
        "logs:DescribeLogGroups"
      ]
      Resource = ["*"]
    },
    {
      Effect = "Allow"
      Action = ["cloudwatch:PutMetricData"]
      Resource = ["*"]
    },
    {
      Effect = "Allow"
      Action = [
        "sqs:ChangeMessageVisibility",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
        "sqs:ReceiveMessage",
        "sqs:SendMessage"
      ]
      Resource = ["*"]
     },
    {
      Effect = "Allow"
      Action = [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:GenerateDataKey*",
        "kms:Encrypt"
      ]
      Resource = ["*"]

    }
  ]
}

module "ecs" {
  source             = "../modules/ecs"
  cluster_name       = var.ecs_cluster_name
  family_name        = var.ecs_family_name
  execution_role_arn = module.ecs_task_execution_role.execution_role_arn #getting this role from output
  cpu                = var.cpu 
  memory             = var.memory 
  container_name     = var.ecs_container_name
  container_image    = module.ecr.repository_url != "" ? "${module.ecr.repository_url}:latest" : "amazonlinux:latest"  # Use the image from ECR if available
  env_var            = var.env_var
  log_region         = var.aws_region
  log_group_name     = "${var.ecs_cluster_name}-logs" # Example: Generate a log group name dynamicallyww
  log_stream_prefix  = "ecs"
}

module "s3_bucket" {
  source      = "../modules/s3"
  bucket_name = var.s3_bucket_name
}


module "mwaa" {
  source                           = "../modules/mwaa"
  environment_name                 = var.environment_name
  airflow_version                  = var.airflow_version
  dag_s3_path                      = var.dag_s3_path
  source_bucket_arn                = module.s3_bucket.bucket_arn
  execution_role_arn               = module.mwaa_role.execution_role_arn
  security_group_ids               = [module.mwaa_env_sg.security_group_id]   ## Use the output from the mwaa_env_sg module
  subnet_ids                       = var.subnet_ids   #var.security_group_ids #
  max_workers                      = var.max_workers
  min_workers                      = var.min_workers
  webserver_access_mode            = var.webserver_access_mode
  enable_dag_processing_logs       = var.enable_dag_processing_logs
  dag_processing_log_level         = var.dag_processing_log_level
  enable_scheduler_logs            = var.enable_scheduler_logs
  scheduler_log_level              = var.scheduler_log_level
  enable_task_logs                 = var.enable_task_logs
  task_log_level                   = var.task_log_level
  enable_webserver_logs            = var.enable_webserver_logs
  webserver_log_level              = var.webserver_log_level
  enable_worker_logs               = var.enable_worker_logs
  worker_log_level                 = var.worker_log_level
  weekly_maintenance_window_start  = var.weekly_maintenance_window_start
  tags                             = var.tags
}

module "mwaa_env_sg" {
  source      = "../modules/SG"
  name        = var.security_group_name
  description = "Security group for MWAA environment"
  vpc_id      = "vpc-05845776"

  ingress_rules = {
    allow_https = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS traffic from anywhere
    }
    allow_internal = {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["10.7.224.0/19"] # Allow internal VPC traffic....
    }
  }

  egress_rules = {
    allow_all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic..
    }
  }

  tags = {
    Name = "mwaa-environment-sg"
  }
}
