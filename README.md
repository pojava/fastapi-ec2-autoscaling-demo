
# FastAPI EC2 Auto Scaling Demo

This repository demonstrates the deployment of a **FastAPI** application with **Auto Scaling** on **AWS EC2** using **Nginx** for reverse proxy and load balancing.

## Features

- **Auto Scaling Group (ASG)** for dynamic scaling of EC2 instances.
- **CloudWatch** monitoring and alarms to track CPU usage and scale accordingly.
- **Nginx** as a reverse proxy for efficient request handling.
- **CI/CD pipeline** using GitHub Actions for automated deployments.
- **Load testing** using Apache Benchmark (ab).

## Prerequisites

- AWS Account
- EC2 instances with **Amazon Linux 2** or other supported distributions
- AWS CLI configured with the required IAM permissions
- Docker installed on EC2 instances

## Setup Instructions

### 1. Clone the repository:

```bash
git clone https://github.com/pojava/fastapi-ec2-autoscaling-demo.git
cd fastapi-ec2-autoscaling-demo
```

### 2. Configure AWS Auto Scaling Group (ASG):

Set up an Auto Scaling group using the AWS CLI to handle dynamic scaling of EC2 instances. To identify your Auto Scaling group name, run the following:

```bash
aws autoscaling describe-auto-scaling-groups --query "AutoScalingGroups[*].AutoScalingGroupName"
```

Use this name in the following scaling policy commands to create scaling policies:

```bash
aws autoscaling put-scaling-policy   --auto-scaling-group-name fastapi-asg   --policy-name scale-up-policy   --scaling-adjustment 1   --adjustment-type ChangeInCapacity   --cooldown 300   --metric-name CPUUtilization   --namespace AWS/EC2   --statistic Average   --period 60   --threshold 80   --comparison-operator GreaterThanThreshold   --evaluation-periods 1
```

### 3. Configure CloudWatch for Monitoring:

Set up alarms in CloudWatch to monitor CPU utilization and trigger auto scaling. Run the following command to set up a high-CPU alarm:

```bash
aws cloudwatch put-metric-alarm   --alarm-name High-CPU-Alarm   --metric-name CPUUtilization   --namespace AWS/EC2   --statistic Average   --period 60   --threshold 80   --comparison-operator GreaterThanThreshold   --evaluation-periods 1   --dimensions "Name=AutoScalingGroupName,Value=fastapi-asg"
```

### 4. Deploy the FastAPI Application on EC2:

To deploy the FastAPI app, you can use Docker and Nginx:

1. Install Docker on your EC2 instances.
2. Create a Docker container for FastAPI, and set up Nginx as a reverse proxy.
3. Make sure to configure Nginx to forward requests to the FastAPI application running on the desired port.

### 5. Set Up a Load Balancer:

Set up an **Application Load Balancer (ALB)** in AWS to distribute incoming traffic across your EC2 instances.

### 6. Configure GitHub Actions for CI/CD:

Set up GitHub Actions to automate the build and deployment process. This will ensure that whenever changes are pushed to the `main` branch, the FastAPI application is automatically built and deployed to EC2 instances. Here is an example GitHub Actions configuration:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      - name: Build Docker image
        run: |
          docker build -t fastapi-app .

      - name: Push Docker image to ECR
        run: |
          # Your commands to push Docker image to ECR

  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to EC2
        run: |
          # Your SSH or SSM commands to deploy the app
```

### 7. Load Testing with Apache Benchmark (ab):

Once everything is set up, you can perform load testing to simulate real-world traffic to your FastAPI application. Install Apache Benchmark and run the following:

```bash
sudo yum install httpd-tools -y
ab -n 1000 -c 10 http://your-alb-url/api/
```

### 8. Debugging and Troubleshooting:

To assist with future debugging, enable detailed logs for Nginx and FastAPI:

- Configure Nginx `access.log` and `error.log` for detailed request logs.
- Adjust the `log_level` in your FastAPI application for better insight.
- Use `curl` for testing API endpoints manually.

Example `curl` command to test the FastAPI endpoint:

```bash
curl http://your-alb-url/api/
```

## Conclusion

This setup ensures that your FastAPI application is scalable, fault-tolerant, and easy to manage using AWS Auto Scaling, CloudWatch, and a robust CI/CD pipeline.


