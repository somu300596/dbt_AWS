# Automating dbt Deployments on AWS 🚀

## Overview
This project automates the deployment and execution of **dbt (Data Build Tool) on AWS** using **GitHub Actions, Docker, AWS ECS (Fargate), and Amazon Managed Workflows for Apache Airflow (MWAA)**. The dbt project runs transformations in **Amazon RDS (PostgreSQL)** and logs execution details in **Amazon CloudWatch**.

## Architecture
The deployment follows these steps:
1️⃣ **Developer pushes dbt changes** to GitHub, triggering GitHub Actions.  
2️⃣ **GitHub Actions builds a Docker image** and pushes it to **Amazon ECR**.  
3️⃣ **AWS Secrets Manager** securely stores **dbt and PostgreSQL credentials**.  
4️⃣ **Airflow (MWAA) detects DAG updates** and triggers a **dbt run**.  
5️⃣ **AWS ECS (Fargate) runs the dbt container** and executes transformations in **Amazon RDS PostgreSQL**.  
6️⃣ **Amazon CloudWatch logs** dbt execution details for monitoring and debugging.  

## Technologies Used
- **dbt (Data Build Tool)** – for transforming data in PostgreSQL  
- **GitHub Actions** – for CI/CD automation  
- **Docker** – for containerizing dbt  
- **Amazon ECR** – for storing container images  
- **AWS Secrets Manager** – for managing credentials securely  
- **Amazon MWAA (Managed Workflows for Apache Airflow)** – for orchestrating dbt workflows  
- **AWS ECS (Fargate)** – for running dbt containers serverlessly  
- **Amazon RDS (PostgreSQL)** – for data storage  
- **Amazon CloudWatch** – for monitoring and logging  

---

## Setup & Deployment

### 1️⃣ Prerequisites
Before getting started, ensure you have:
- An **AWS account** with permissions to use **ECS, ECR, MWAA, RDS, and Secrets Manager**.
- A **GitHub repository** with your **dbt project**.
- **Docker installed** on your local machine.

### 2️⃣ Setting up AWS Resources
1. **Create an Amazon RDS PostgreSQL instance** and configure access.  
2. **Store credentials in AWS Secrets Manager**:
   ```json
   {
     "dbt_postgres_host": "your-rds-endpoint",
     "dbt_postgres_user": "your-username",
     "dbt_postgres_password": "your-password",
     "dbt_postgres_database": "your-db"
   }
   ```
3. **Create an Amazon ECR repository** to store the dbt container image.  
4. **Set up MWAA (Apache Airflow) on AWS** and configure DAGs.  

### 3️⃣ Configuring GitHub Actions
Add the following secrets to your GitHub repository:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `ECR_REPOSITORY`
- `DBT_PROFILES_YML`

Modify `.github/workflows/deploy.yml` to include:
```yaml
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Login to AWS ECR
        run: |
          aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${{ secrets.ECR_REPOSITORY }}

      - name: Build and push Docker image
        run: |
          docker build -t dbt-project .
          docker tag dbt-project:latest ${{ secrets.ECR_REPOSITORY }}:latest
          docker push ${{ secrets.ECR_REPOSITORY }}:latest
```

### 4️⃣ Deploying dbt on AWS
- Push dbt project updates to GitHub → Triggers GitHub Actions  
- Actions build and push a **Docker image** to Amazon ECR  
- Airflow DAG detects new changes → **Triggers a dbt run on AWS ECS (Fargate)**  
- Execution logs are available in **Amazon CloudWatch**  

---

## Monitoring & Debugging
- View **Airflow DAGs** in the AWS MWAA console.  
- Check **ECS task logs** in **Amazon CloudWatch**.  
- Validate **dbt transformations** in **Amazon RDS PostgreSQL**.

---

## Future Improvements
🔹 Add **Terraform or AWS CDK** for infrastructure automation  
🔹 Implement **AWS Lambda** for event-driven dbt execution  
🔹 Enable **cost optimization** using spot instances  

---

## Contributions
Feel free to open issues, suggest improvements, or submit PRs to enhance this project! 🚀  

**#dbt #AWS #GitHubActions #Docker #ApacheAirflow #AWSFargate #PostgreSQL #DevOps #DataEngineering #CloudComputing**
