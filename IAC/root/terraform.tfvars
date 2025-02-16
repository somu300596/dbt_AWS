aws_region           = "cn-northwest-1"
ecr_repository_name  = "dbt-repo1"
iam_role_name        = "ecs-task-execution-role"   #role for ecs task execution
ecs_cluster_name     = "dbt-cluster"   #cluster-name
ecs_family_name      = "dbt-task"    #task-definition name
cpu                  = "1024"
memory               = "2048"
ecs_container_name   = "dbt-container"  #container-name
env_var = [{}] # here i am getting the snowflake creds form gitlab enivronment varibles section, i have tested
# from the secret manager as well. To use the secret manager un-comment the following section. 
# env_var = [
#   {
#     name      = "SNOWFLAKE_ACCOUNT"
#     valueFrom = "arn of secrets form secret manager"
#   },
#   {
#     name      = "SNOWFLAKE_PASSWORD"
#     valueFrom = "arn of secrets form secret manager"
#   },
#   {
#     name      = "SNOWFLAKE_USER"
#     valueFrom = "arn of secrets form secret manager"
#   }
# ]

s3_bucket_name       = "dbt-bucket"

#########Airflow variables###
environment_name                 = "mwaa-environment1"
airflow_version                  = "2.10.1"
dag_s3_path                      = "dags/"
# source_bucket_arn                = "arn:aws-cn:s3:::dbt-bucket"
# execution_role_arn               = "arn:aws-cn:iam::123456789012:role/mwaa-execution-role"
#security_group_ids               = ["sg-0b052662b6e5c28"] 
subnet_ids                       = ["subnet-055e42c6aab2", "subnet-0952da76796d1"]
max_workers                      = 
min_workers                      = 1
webserver_access_mode            = "PUBLIC_ONLY"
enable_dag_processing_logs       = true
dag_processing_log_level         = "INFO"
enable_scheduler_logs            = true
scheduler_log_level              = "INFO"
enable_task_logs                 = true
task_log_level                   = "INFO"
enable_webserver_logs            = true
webserver_log_level              = "INFO"
enable_worker_logs               = true
worker_log_level                 = "INFO"
weekly_maintenance_window_start  = "SUN:03:00"
tags                             = {
  "Environment" = "dev"
  "Project"     = "MWAA"
}

security_group_name = "mwaa-environment-sg1"
