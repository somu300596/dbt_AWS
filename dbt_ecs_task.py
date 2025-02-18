from airflow import DAG
from airflow.providers.amazon.aws.operators.ecs import EcsRunTaskOperator
from airflow.utils.dates import days_ago
from airflow.operators.dummy import DummyOperator

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

# Define the DAG
with DAG(
    dag_id='dbt_ecs_task',
    default_args=default_args,
    description='Run dbt container on ECS',
    schedule_interval='@daily',  # Schedule to run every 24 hours
    start_date=days_ago(1),
    catchup=False,  # Avoid running past missed intervals
) as dag:
    
    # Start task
    start_task = DummyOperator(
        task_id='start'
    )
    
    # ECS task execution
    run_dbt_container = EcsRunTaskOperator(
        task_id='{{ task_id }}',
        cluster='{{ cluster }}',  # ECS cluster name
        task_definition='{{ task_definition }}',  # ECS task definition ARN
        launch_type='FARGATE',
        overrides={
            'containerOverrides': [
                {
                    'name': 'dbt-container',  # Replace with the container name in the ECS task definition
                    # 'command': ['dbt', 'run'],  # Adjust the command to run dbt or modify as needed
                }
            ],
        },
        network_configuration={
            'awsvpcConfiguration': {
                'subnets': [{{ subnets }}],  # Subnet IDs passed dynamically
                'securityGroups': ['{{ security_groups }}'],  # Security group IDs passed dynamically
            },
        },
    )

    # End task
    end_task = DummyOperator(
        task_id='end'
    )

    # Define task dependencies
    start_task >> run_dbt_container >> end_task

# from airflow import DAG
# from airflow.providers.amazon.aws.operators.ecs import EcsRunTaskOperator
# from airflow.utils.dates import days_ago
# from airflow.operators.dummy import DummyOperator

# # Default arguments for the DAG
# default_args = {
#     'owner': 'airflow',
#     'depends_on_past': False,
#     'email_on_failure': False,
#     'email_on_retry': False,
#     'retries': 1,
# }

# # Define the DAG
# with DAG(
#     dag_id='dbt_ecs_task',
#     default_args=default_args,
#     description='Run dbt container on ECS',
#     schedule_interval='@daily',  # Schedule to run every 24 hours
#     #schedule_interval='*/60 * * * *',  # Runs every 3 minutes
#     start_date=days_ago(1),
#     catchup=False,  # Avoid running past missed intervals
# ) as dag:
    
#     # Start task
#     start_task = DummyOperator(
#         task_id='start'
#     )
    
#     # ECS task execution
#     run_dbt_container = EcsRunTaskOperator(
#     task_id='dbt-container',
#     cluster='dbt-cluster',  # Replace with your ECS cluster name
#     task_definition='dbt-task',  # Replace with your ECS task definition name and revision
#     launch_type='FARGATE',
#     overrides={
#         'containerOverrides': [
#             {
#                 'name': 'dbt-container',  # Replace with the container name in the ECS task definition
#                 #'command': ["dbt", "run"],  # Adjust as per the dbt task you want to executee
#             }
#         ],
#     },
#     network_configuration={
#         'awsvpcConfiguration': {
#             'subnets': ['subnet-0952da7674096d12b'],  # Replace with your VPC subnet IDs
#             'securityGroups': ['sg-0fd26f4eb83d71d7e']  ## MWAA SG Replace with your security group IDs
#             #'assignPublicIp': 'ENABLED',  # ENABLED if public access is requiredd
#         },
#     },
# )
#     end_task = DummyOperator(
#         task_id='end'
#     )

#     # Define task dependencies
#     start_task >> run_dbt_container >> end_task
