# 2048 Game - AWS ECS Deployment

A containerized 2048 game deployed on AWS using ECS Fargate with automated CI/CD pipeline.

## Architecture

```
GitHub Actions → ECR → ECS Fargate → Application Load Balancer → Internet
```

## Infrastructure Components

- **ECS Fargate**: Serverless container hosting
- **Application Load Balancer**: Traffic distribution and health checks
- **ECR**: Container image registry
- **CloudWatch**: Logging and monitoring
- **IAM**: Security roles and permissions

## Prerequisites

- AWS Account with appropriate permissions
- GitHub repository
- Docker installed locally
- Terraform installed

## AWS Infrastructure Setup

### 1. Configure AWS Credentials

Ensure your AWS credentials are configured with the following managed policies:
- `AmazonECS_FullAccess`
- `AmazonEC2ContainerRegistryFullAccess`
- `AmazonVPCFullAccess`
- `CloudWatchLogsFullAccess`
- `ElasticLoadBalancingFullAccess`
- `IAMFullAccess`

### 2. Deploy Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

This creates:
- ECS Cluster: `2048-cluster`
- ECR Repository: `2048-game-repo`
- Application Load Balancer: `2048-game-alb`
- ECS Service: `2048-service`
- Security Groups and IAM roles

### 3. Get Load Balancer URL

After deployment, find your application URL:
```bash
aws elbv2 describe-load-balancers --names "2048-game-alb" --query 'LoadBalancers[0].DNSName' --output text
```

Or check: AWS Console → EC2 → Load Balancers → 2048-game-alb

## CI/CD Setup

### 1. GitHub Secrets

Add these secrets to your GitHub repository (Settings → Secrets → Actions):

- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key

### 2. GitHub Actions Workflow

The pipeline automatically:
1. **Build**: Creates Docker image from your application
2. **Test**: Runs application tests inside the container
3. **Deploy**: Pushes image to ECR and updates ECS service

Triggered on every push to `main` branch.

## File Structure

```
project/
├── .github/workflows/
│   └── deploy.yml          # CI/CD pipeline
├── docker/
│   └── Dockerfile          # Container configuration
├── terraform/
│   ├── main.tf            # Infrastructure definition
│   ├── variables.tf       # Configuration variables
│   └── outputs.tf         # Infrastructure outputs
├── src/                   # Application source code
└── README.md
```

## Configuration

### Terraform Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `aws_region` | us-east-1 | AWS deployment region |
| `project_name` | 2048-game | Project identifier |
| `environment` | dev | Environment name |
| `app_port` | 80 | Application container port |

### GitHub Actions Environment Variables

```yaml
AWS_REGION: us-east-1
ECR_REPOSITORY: 2048-game-repo
PROJECT_NAME: 2048-game
ECS_SERVICE_NAME: 2048-service
ECS_CLUSTER_NAME: 2048-cluster
```

## Deployment Process

1. **Code Push**: Developer pushes code to main branch
2. **Build Stage**: GitHub Actions builds Docker image and pushes to ECR
3. **Test Stage**: Runs tests on the built container image
4. **Deploy Stage**: Updates ECS service with new image
5. **Health Checks**: Load balancer verifies application health
6. **Live**: Application accessible via load balancer URL

## Monitoring

- **CloudWatch Logs**: Application logs in `/ecs/2048-game`
- **ECS Console**: Service health and task status
- **Load Balancer**: Health check status and metrics

## Cost Estimation

Monthly costs (approximate):
- Application Load Balancer: $16-22
- ECS Fargate (256 CPU, 512MB): $13
- ECR Storage: $1
- CloudWatch Logs: $1-3
- Data Transfer: $0-5

**Total: ~$31/month**

## Troubleshooting

### Common Issues

**ECS Service Won't Start**:
- Check CloudWatch logs for container errors
- Verify health check path returns HTTP 200
- Ensure security groups allow traffic on app_port

**GitHub Actions Fails**:
- Verify AWS credentials in GitHub secrets
- Check IAM permissions for ECS and ECR access
- Ensure Dockerfile path is correct

**Load Balancer Returns 503**:
- No healthy ECS tasks are running
- Check ECS service events for deployment issues
- Verify target group health check configuration

### Useful Commands

```bash
# Check ECS service status
aws ecs describe-services --cluster 2048-cluster --services 2048-service

# View recent ECS events
aws ecs describe-services --cluster 2048-cluster --services 2048-service --query 'services[0].events[0:5]'

# Check application logs
aws logs tail /ecs/2048-game --follow

# Force new deployment
aws ecs update-service --cluster 2048-cluster --service 2048-service --force-new-deployment
```

## Cleanup

To destroy all AWS resources:

```bash
cd terraform
terraform destroy
```

This will remove all infrastructure and stop billing.

## Security Notes

- Application Load Balancer accepts traffic from internet (0.0.0.0/0)
- ECS tasks only accept traffic from load balancer
- Container runs on Fargate (managed infrastructure)
- All AWS resources are tagged for identification

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with Docker
5. Submit a pull request

Changes to `main` branch trigger automatic deployment. #testing run for actions
